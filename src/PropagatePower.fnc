/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                     |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     PropagatePower.fnc											                     |
 | Author(s):     Jonathan Fuzaro Alencar, Michael Stich                       |
 | Date(s):       February 2020, March 2023                                    |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

#ifndef __PROPAGATE_POWER__
#define __PROPAGATE_POWER__

// depth-first traversal of circuit graph to populate component port power type
void propagatePower() {

  string powerType = ElectricPowerType;
  string port = refport->getPathName();
  string portComponent = port->parent.isA();
  // Start off by putting this first component in the list.
  if (!powerComponentListSourceToLoad.contains(parent.parent.getPathName())) {
      powerComponentListSourceToLoad.append(parent.parent.getPathName());
  }

  while (!sourceComponents.contains(portComponent)
          && !loadComponents.contains(portComponent)) {

    // Update ordered list of components as we go as well.
    // If we've already crawled a component, move it back to the top
    // (makes the display order in the viewOut files look better).
    if (powerComponentListSourceToLoad.contains(port->parent.getPathName())) {
      powerComponentListSourceToLoad.remove(port->parent.getPathName());
    }
    powerComponentListSourceToLoad.append(port->parent.getPathName());
    if (portComponent == "Enode") { // check if port is a node
      port->setOption("ElectricPowerType", powerType);
      propagateNode(port);
      break;
    } else if (!converterComponents.contains(portComponent)) { // ignore conversion ports
      port->setOption("ElectricPowerType", powerType);
      port = getOtherPort(port);
      port->setOption("ElectricPowerType", powerType);
    } else { // skip setting conversion ports but change branch power type
      port = getOtherPort(port);
      powerType = port->ElectricPowerType;
    }
    port = (port->refport)->getPathName(); // move to linked port
    portComponent = port->parent.isA();
  }

  // Add the last component to the list.
  if (!powerComponentListSourceToLoad.contains(port->parent.getPathName())) {
    powerComponentListSourceToLoad.append(port->parent.getPathName());
  }

  if (sourceComponents.contains(portComponent) && port->ElectricPowerType != powerType) {
    cerr << "\n[ERROR]: Found source component with conflicting power type!\n";
    return;
  }
  port->setOption("ElectricPowerType", powerType);
}

// this is called when propagatePower() encounters a node
void propagateNode(string originPort) {

  string port = originPort;
  string powerType = port->ElectricPowerType;
  string nodePorts[] = port->parent.list("ElectricPort", TRUE);

  (port->parent.getPathName())->setOption("ElectricPowerType", powerType);

  int i;
  for (i = 0; i < nodePorts.entries(); i++) {
    port = nodePorts[i];
    if (port != originPort) {
      port->setOption("ElectricPowerType", powerType);
      port->propagatePower();
    }
  }
}

// sets component power type on both input and output ports of component
string getOtherPort(string port) {
  if (port->isA() == "ElectricInputPort") {
    return port->parent.EP_O.getPathName();
  } else {
    return port->parent.EP_I.getPathName();
  }
}

// Updates the defaultElectricalSolverSequence array and checks if what is trying to be inputted is already in the array
void updateDefaultElectricalSolverSequence(string port) {
  port = port->parent.getName();
  if (!(defaultElectricalSolverSequence.contains(port))) {
  defaultElectricalSolverSequence.append(port);
  }
}

// Extracts the name of the port from the passed string
string trimName(string port) {
  port = port->parent.getName();
  return port;
}

// Peeks into the next port's relative name
string nextPort() {
  string port = refport->getPathName();
  return port;
}

// Crawls through the design with a depth-first search and populates EnodesInDesign with all the inputs for the Enodes
void scanDesign() {
  string port = refport->getPathName();
  string portComponent = port->parent.isA();
  //cout << "Port: " << port << endl;

  if (!(portComponent == "Enode")) {
    // Runs a check if this is the last component in the branch
    string nodeOutputPorts[] = port->parent.list("ElectricOutputPort");
    if (nodeOutputPorts.entries() >= 1) {
      string next = getOtherPort(port);
      string check = next->nextPort();
      if (check->parent.isA() == "Enode") {
        string trimmedPort = trimName(port);
        string trimmedEnode = trimName(check);

        // This loop scans the EnodesInDesign 2d string for the 
        int i;
        int sizeEnodes = EnodesInDesign.entries();
        for (i = 0; i < sizeEnodes; i++) {
          string current[] = EnodesInDesign[i];
          if(current.contains(trimmedEnode)){
            if(!(current.contains(trimmedPort))) {
              current.append(trimmedPort);
              EnodesInDesign[i] = current;
            }
          }
        }
      }
      next->scanDesign();
    }
  }
  else {
    string nodeOutputPorts[] = port->parent.list("ElectricOutputPort");
    int i;
    int currOutputPorts = nodeOutputPorts.entries();
    for (i = 0; i < currOutputPorts; i++) {
      nodeOutputPorts[i]->scanDesign();
    }
  }
}

// Crawls through the design with a depth first search, adding components when needed to the defaultElectricalSolverSequence
void crawlThroughDesign() {
  string port = refport->getPathName();
  string portComponent = port->parent.isA();
  //cout << "Port: " << port << endl;

  if (!(portComponent == "Enode")) {
    updateDefaultElectricalSolverSequence(port);
    // Runs a check if this is the last component in the branch
    string nodeOutputPorts[] = port->parent.list("ElectricOutputPort");
    if (nodeOutputPorts.entries() >= 1) {
      string next = getOtherPort(port);
      next->crawlThroughDesign();
    }
  }
  else {
    string nodeInputPorts[] = port->parent.list("ElectricInputPort");
    string nodeOutputPorts[] = port->parent.list("ElectricOutputPort");
    
    if (nodeInputPorts.entries() == 1) {
      updateDefaultElectricalSolverSequence(port);
      int i;
      int currOutputs = nodeOutputPorts.entries();
      for (i = 0; i < currOutputs; i++) {
        nodeOutputPorts[i]->crawlThroughDesign();
      }
    }
    else if (nodeInputPorts.entries() > 1) {
      string trimmedEnode = trimName(port);
      int i;
      int currNodes = EnodesInDesign.entries();
      for (i = 0; i < currNodes; i++) {
          string current[] = EnodesInDesign[i];
          if(current.contains(trimmedEnode)) {
            string tempComp;
            int j;
            int boolian = 1;
            int currEntries = current.entries();
            for(j = 1; j < currEntries; j++) {
              tempComp = current[j];
              if(!(defaultElectricalSolverSequence.contains(tempComp))) {
                boolian = 0;
              }
            }
            if (boolian == 1) {
              updateDefaultElectricalSolverSequence(port);
              int c;
              int currNodeOut = nodeOutputPorts.entries();
              for (c = 0; c < currNodeOut; c++) {
              nodeOutputPorts[c]->crawlThroughDesign();
              }
            }
          }
        }
    }
  }
}
#endif
