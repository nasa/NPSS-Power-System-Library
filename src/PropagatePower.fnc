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

  string port = refport->getPathName();
  string powerType = port->ElectricPowerType;
  string portComponent;

  while (!singlePortComponents.contains(portComponent)) {

    portComponent = port->parent.isA();
    cout << "Current Port: " << port << endl;

    if (portComponent != "Enode") { // check if port is a node
      if (!converterComponenets.contains(portComponent)) { // ignore conversion ports
        port->setOption("ElectricPowerType", powerType);
        port = getOtherPort(port);
        port->setOption("ElectricPowerType", powerType);
        cout << "Current Port: " << port << endl;
      } else { // skip setting conversion ports but change branch power type
        port = getOtherPort();
        powerType = port->ElectricPowerType;
      }
      port = (port->refport)->getPathName(); // move to linked port
      cout << "Current Port: " << port << endl;
    } else {
      port->setOption("ElectricPowerType", powerType);
      propagateNode(port);
      break;
    }
  }
  port->setOption("ElectricPowerType", powerType);
  k++;
}

void propagateNode(string originPort) {

  string port = originPort;
  string powerType = port->ElectricPowerType;
  string nodePorts[] = port->parent.ElectricPorts;
  cout << "Node " << port->parent.getName() << " Ports: \n" << nodePorts << endl;

  int i;
  for (i = 0; i < nodePorts.entries(); i++) {
    port = nodePorts[i]->getPathName();
    cout << "Current Port: " << (nodePorts[i])->getPathName() << endl;
    if (port != originPort) {
      port->setOption("ElectricPowerType", powerType);
      port->propagatePower();
    }
  }
}
#endif