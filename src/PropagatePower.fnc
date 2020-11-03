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

// depth-first traversal of circuit graph to populate component port power type
void propagatePower() {

  string powerType = ElectricPowerType;
  string port = refport->getPathName();
  string portComponent = port->parent.isA();

  while (!sourceComponents.contains(portComponent)
          && !loadComponents.contains(portComponent)) {
    string parentComponent = port->parent.getPathName();
    // Update ordered list of components as we go as well.
    // If the first component we've crawled, just put it straight into the list
    if (powerComponentListSourceToLoad.entries() < 1) {
      powerComponentListSourceToLoad.append(parentComponent);
    }
    // If we've already crawled a component, verify next one isn't already in the list before we put it in.
    else if (!powerComponentListSourceToLoad.contains(parentComponent)) {
      powerComponentListSourceToLoad.append(parentComponent);
    }
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

// propagates power type across node branches
void propagateNode(string originPort) {

  string port = originPort;
  string powerType = port->ElectricPowerType;
  string nodePorts[] = port->parent.list("ElectricOutputPort", FALSE);

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
#endif
