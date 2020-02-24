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

#include "ElectricPort.prt"

string converterComponenets[] = { "Inverter", "Rectifier", "DC_DC_Converter" };
string singlePortComponents[] = { "Generator", "Motor", "Source", "ConstantPowerLoad" };

// sets component power type the same on both input and output ports
string getOtherPort(string port) {
  if (port->isA() == "ElectricInputPort") {
    return port->parent.EP_O.getPathName();
  } else {
    return port->parent.EP_I.getPathName();
  }
}

// depth-first traversal of circuit graph to populate port power type
void propagatePower() {

  string powerType = ElectricPowerType;
  string port = refport->getPathName();
  string portComponent = port->parent.isA();

  while (!singlePortComponents.contains(portComponent)) {
    if (portComponent != "Enode") { // check if port is a node
      if (!converterComponenets.contains(portComponent)) { // ignore conversion ports
        port->setOption("ElectricPowerType", powerType);
        cout << "Setting port " << port << " to power type: " << powerType << endl;
        port = getOtherPort(port);
        port->setOption("ElectricPowerType", powerType);
        cout << "Setting port " << port << " to power type: " << powerType << endl;
      } else { // skip setting conversion ports but change branch power type
        port = getOtherPort(port);
        powerType = port->ElectricPowerType;
        cout << "Found " << port << ", setting power type to: " << powerType << endl;
      }
      port = (port->refport)->getPathName(); // move to linked port
    } else {
      port->setOption("ElectricPowerType", powerType);
      propagateNode(port);
      break;
    }
    portComponent = port->parent.isA();
  }
  port->setOption("ElectricPowerType", powerType);
}

void propagateNode(string originPort) {

  string port = originPort;
  string powerType = port->ElectricPowerType;
  string nodePorts[] = port->parent.ElectricPorts;

  int i;
  for (i = 0; i < nodePorts.entries(); i++) {
    port = port->parent.getPathName() + "." + nodePorts[i];
    cout << "Current Port: " << port << endl;
    if (port != originPort) {
      port->setOption("ElectricPowerType", powerType);
      cout << "Propagating power on port: " << port << endl;
      port->propagatePower();
    }
  }
}
#endif