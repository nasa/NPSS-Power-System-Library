/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                     |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     PropagatePower.fnc											                     |
 | Author(s):     Jonathan Fuzaro Alencar                                      |
 | Date(s):       February 2020                                                |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

#ifndef __PROPAGATE_POWER__
#define __PROPAGATE_POWER__

string sourceComponents[] = { "Source", "Generator" };
string loadComponents[] = { "Motor", "ConstantPowerLoad" };
string converterComponents[] = { "Inverter", "Rectifier", "DC_DC_Converter" };

void findSourceAndPropagate() {

  string portComponent;
  string ports[] = solver.list("ElectricPort", TRUE);

  int i;
  for (i = 0; i < ports.entries(); i++) {

    portComponent = ports[i]->parent.isA();

    // search for undefined power source ports and propagate their subgraph
    if (sourceComponents.contains(portComponent)
        && ports[i]->ElectricPowerType == "UNDEF") {
      ports[i]->propagatePower();
    }
  }
}

// depth-first traversal of circuit graph to populate port power type
void propagatePower() {

  string powerType = ElectricPowerType;
  string port = refport->getPathName();
  string portComponent = port->parent.isA();

  while (!sourceComponents.contains(portComponent)
          && !loadComponents.contains(portComponent)) {
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
  string nodePorts[] = port->parent.ElectricPorts;

  (port->parent.getPathName())->setOption("ElectricPowerType", powerType);

  int i;
  for (i = 0; i < nodePorts.entries(); i++) {
    port = port->parent.getPathName() + "." + nodePorts[i];
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
#endif