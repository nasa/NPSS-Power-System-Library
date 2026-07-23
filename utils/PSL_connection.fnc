/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                   |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     PropagatePower.fnc										   |
 | Author(s):     Jeffryes Chapman, Jonathan Fuzaro Alencar                    |
 | Date(s):       August 2025                                                  |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

// depth-first traversal of circuit graph to populate component port power type
void propagatePower() {
  /*
      This function propgates the power type for an electrical system model.  This is done with the following steps.
      1) Look through model for all links created by LinkPorts
      2) for Each Link where the outport is an ElectricOutputPort the algorithm will
        a) if the outport elment is a source or converter type, set inport and outport switchPowerType equal.
        b) if the inport element is not a load or a converter, 
        set the the switchPowerType of the input element equal to the element's inport switchPowerType (this will 
        make the element's input and output switchPowerType the same)
  */
  string sourceComponents[] = { "Source", "Generator", "Battery" };
  string loadComponents[] = { "Motor", "ConstantPowerLoad" };
  string converterComponents[] = { "Inverter", "Rectifier", "DC_DC_Converter" };

  string Links[] = list("Link", TRUE);
  int n;
  for (n=0; n < Links.entries(); ++n ) {
    string EPOname = Links[n]->getP1Name();
    string EPIname = Links[n]->getP2Name();
    if (evalExpr(EPOname+".isA()")=="ElectricOutputPort"){
      // if element containing EP_O is a source or converter propogate switch power type from EP_O to the connected EP_I
      if (sourceComponents.contains(EPOname->parent.isA()) || converterComponents.contains(EPOname->parent.isA()) ) {
        EPIname->switchPowerType = EPOname->switchPowerType;
      }
      // if element containing EP_I is not a load or converter copy power type from its input to its output
      if (!loadComponents.contains(EPIname->parent.isA()) && !converterComponents.contains(EPIname->parent.isA())){
        EPIname->parent.setOption("switchPowerType", EPIname->switchPowerType);
      } 
    }
  }
  checkPowerTypeConsistency();
}


// propagateEpsSolverListAndPowerTypes finds valid defined sources and propagates their power type
// propagateEpsSolverListAndPowerTypes appends the defaultElectricalSolverSequence array with the right components to be passed into solverSequence
string [] electricalSolverSequenceSetup() {
  /*
      This function sets the electrical system solver sequence for the model by generating a string array (ElectricalSolverSequence) with the ideal setup.
      The function operates in two main steps
      1) Search the model for source components and track them along their electrical path until they get to a node. 
        a) Add these lists of electrical elements to the ElectricalSolverSequence, note.  The node will not be added at this time
        b) Create list of nodes encountered in this task (EnodesToPopulate).
      2) Go through each of node in EnodesToPopulate.  If the node inports are fully defined track along thier electrical path until they get to another node (same as in #1)
        a) Add these new elements to the ElectricalSolverSequence, add any new nodes to the EnodesToPopulate, then remove the fully defined enode from EnodesToPopulate.
        b) repeat 2->2a->2b until the ElectricalSolverSequence is fully defined.
  */

  string sourceComponents[] = { "Source", "Generator", "Battery" };
  string loadComponents[] = { "Motor", "ConstantPowerLoad" };
  string converterComponents[] = { "Inverter", "Rectifier", "DC_DC_Converter" };

  string ElectricalSolverSequence[];
  string portComponent;
  string NextPort, ElementOutport;
  string ports[] = list("ElectricOutputPort", TRUE);
  int designEntries = ports.entries();
  int WalkThroughLine_EN;
  string EnodesToPopulate[];
  int i, n;
  //---------------------------------------------------------------------------------------------
  // Start by searching for source components and populating ElectricalSolverSequence and connections until enode
  // Create list of EnodesToPopulate for operating later
  //---------------------------------------------------------------------------------------------
  for (i = 0; i < designEntries; i++) {
    portComponent = ports[i]->parent.isA();
    //search for undefined power source ports and propagate their subgraph
    if (sourceComponents.contains(portComponent)) {
      //Calls recursive function scanDesign populates the EnodesInDesign 2d array with all the component inputs for the Enodes
      WalkThroughLine_EN = TRUE;
      // walkthrough design and populate solver sequence for source lines
      ElectricalSolverSequence.append(trimName(ports[i]));
      // get next component element name
      NextPort = ports[i]->isLinkedTo();
      while (WalkThroughLine_EN) {
        if ( NextPort->parent.isA() == "Enode") {
          // if element is an enode do not populate the solver sequence and end loop.
          if (!EnodesToPopulate.contains(NextPort->parent.getPathName())){
            EnodesToPopulate.append(NextPort->parent.getPathName());
          }
          WalkThroughLine_EN = FALSE;

        } else if (loadComponents.contains(NextPort->parent.isA())) {
          // if element is a load populate the solver sequence and end loop.
          ElectricalSolverSequence.append(trimName(NextPort));
          WalkThroughLine_EN = FALSE;

        } else {
          // Populate the solver sequence and move to next input port
          ElectricalSolverSequence.append(trimName(NextPort));
          ElementOutport = NextPort->parent.getPathName()+".EP_O";
          NextPort = ElementOutport->isLinkedTo();
        }
      }
    }
  }
  //----------------------------------------------------------------------
  // Next walk nodes until they have all been walked using EnodesToPopulate
  //-----------------------------------------------------------------------
  int WalkThroughNodes_EN;
  if (EnodesToPopulate.entries()==0){
    WalkThroughNodes_EN = FALSE;
  } else {
    WalkThroughNodes_EN = TRUE;
  }
  string CurrentEnode, CurrentInputName;
  string EnodeInputList[];
  string EnodeOutputList[];
  string EnodesToRemove[];
  int NumberOfEnodes;
  int EnodeInputFullyDefined = TRUE;

  while (WalkThroughNodes_EN){
    NumberOfEnodes = EnodesToPopulate.entries();

    for (i = 0; i < NumberOfEnodes; i++) {
      CurrentEnode = EnodesToPopulate[i];
      // Get list of all Current Enodes inputs
      EnodeInputList = CurrentEnode->list("ElectricInputPort", TRUE);
      //Check if all elements input to this Enode are already in the ElectricalSolverSequence
      EnodeInputFullyDefined = TRUE;
      for (n = 0; n < EnodeInputList.entries(); n++) {
        CurrentInputName = trimName(EnodeInputList[i]->isLinkedTo());
        if (!ElectricalSolverSequence.contains(CurrentInputName)) {
          EnodeInputFullyDefined = FALSE;
        }
      }

      // if the Enode inputs are fully defined
      // add enode and walk through each of its output lines then add them to the ElectricalSolverSequence
      if (EnodeInputFullyDefined){
        // Populate Enode lines.
        ElectricalSolverSequence.append(CurrentEnode->getName());
        // Gather list of outputs for current enode to be walked through
        EnodeOutputList = CurrentEnode->list("ElectricOutputPort", TRUE);
        // For each of these outputs walk through the circuit line
        for (n = 0; n<EnodeOutputList.entries(); n++){
          WalkThroughLine_EN = TRUE;
          NextPort = EnodeOutputList[n]->isLinkedTo();

          while (WalkThroughLine_EN) {
            if ( NextPort->parent.isA() == "Enode") {
              // if element is an enode do not populate the solver sequence and end loop.
              if (!EnodesToPopulate.contains(NextPort->parent.getPathName())){
                EnodesToPopulate.append(NextPort->parent.getPathName());
              }
              WalkThroughLine_EN = FALSE;

            } else if (loadComponents.contains(NextPort->parent.isA())) {
              // if element is a load populate the solver sequence and end loop.
              ElectricalSolverSequence.append(trimName(NextPort));
              WalkThroughLine_EN = FALSE;

            } else {
              // Populate the solver sequence and move to next input port
              ElectricalSolverSequence.append(trimName(NextPort));
              ElementOutport = NextPort->parent.getPathName()+".EP_O";
              NextPort = ElementOutport->isLinkedTo();
            }
          }
        }
        // Remove the Enode you just populated from the to do list.
        EnodesToRemove.append(EnodesToPopulate[i]);
      }
    }

    //-------------------------------------------------------------------------------------------------
    // if you failed to populate any of the enodes after looping through all of them exit, it is hopeless.
    //-------------------------------------------------------------------------------------------------
    if (EnodesToRemove.entries() == 0 && EnodesToPoulate.entries() > 0){
      cerr<<"electricalSolverSequenceSetup has failed. Do not trust results"<<endl;
      return ElectricalSolverSequence;  
    
    //-------------------------------------------------------------------------------------------------
    // Pull Enodes to remove from Enodes to populate. You are done if there are no move Enodes.
    //-------------------------------------------------------------------------------------------------
    } else {
      for (n=0; n<EnodesToRemove.entries(); n++){
        EnodesToPopulate.remove(EnodesToRemove[n]);
      }
      if (EnodesToPopulate.entries() == 0){
        WalkThroughNodes_EN = FALSE;
      }else {
        EnodesToRemove = {};
      }
    }
    
  }
  
  return ElectricalSolverSequence;
}

void checkPowerTypeConsistency() {
  /* This function check to see if inport and outport power types match for each Electric port connection*/
  string Links[] = list("Link", TRUE);
  string EPOname, EPIname;
  int n;
  for (n=0; n < Links.entries(); ++n ) {
    EPOname = Links[n]->getP1Name();
    EPIname = Links[n]->getP2Name();
    if ((evalExpr(EPOname+".isA()")=="ElectricOutputPort")&&(EPOname->switchPowerType != EPIname->switchPowerType)){
      cerr<< " Connection Error : "<<EPOname<<" power type does not equal "<<EPIname<<" power type."<<endl;
    }
  }
}

// Extracts the name of the port from the passed string
string trimName(string port) {
  port = port->parent.getName();
  return port;
}