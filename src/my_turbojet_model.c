//
//  Exercise 7, Part II: Off-Design Runs of the Turbojet Model
//    note: HPC, HPT map files now included


// declare the thermodynamics package to be used
setThermoPackage( "GasTbl" );

#include <engine_TurbinePRmap3D.int>
#include "ElectricPort.prt"
#include "InterpretedPort.int"
#include<Generator.int>
#include<Motor.int>

// instantiate the Elements in this model
// syntax is: 
// Element elementType elementName { }

Element Ambient ambient {
   alt_in = 10000.;
   MN_in = 0.40;
} 


Element InletStart start {
   W_in = 100.;
}
Element InletStart propStart {
   W_in = 100.;
}
Element FlowEnd propStop {
}


Element Inlet inlet { 
   eRamBase = 0.9800;
} 


Element Compressor HPC { 
   #include <hpcV26.map>
   PRdes = 20.;
   effDes = 0.90;
   //NcDes = 100.;
} 


Element FuelStart fuelIn { 
   LHV = 18500.;
} 


Element Burner burner { 
   switchBurn = "FAR";
   FAR = 0.0300;
} 


Element Turbine HPT { 
   #include <hptV26.map>
   PRbase = 4.00;
   effDes = 0.90;
   //S_map.PRmapDes = 4.5;
   //NpDes = 100.;
} 

Element Turbine powerT {
   #include <hptV26.map>
   PRbase = 4.;
   effDes = .9;
}

Element Nozzle nozzle { 
   switchType = "CONIC";
   PsExhName = "ambient.Ps";
} 


Element FlowEnd end { 
} 

Element Generator generator {

}

Element Motor motor {

}

Element Propeller prop {

}


Element Shaft shaft { 
   ShaftInputPort HPClink;
   ShaftInputPort HPTlink;
   Nmech = 5000.;
} 

Element Shaft powerShaft {
   ShaftInputPort powerTlink;
   ShaftInputPort genlink;
   Nmech = 5000;
}

Element Shaft propShaft {
   ShaftInputPort motorlink;
   ShaftInputPort proplink;
   Nmech = 5000;
}

Element Enode En{
   ElectricInputPort EP_I;
   ElectricOutputPort EP_O;
}


// link the Elements together via their Ports
linkPorts( "start.Fl_O",   "inlet.Fl_I",    "station0"  );
linkPorts( "inlet.Fl_O",   "HPC.Fl_I",      "station2"  );
linkPorts( "HPC.Fl_O",     "burner.Fl_I",   "station3"  );
linkPorts( "fuelIn.Fu_O",  "burner.Fu_I",   "stationF"  );
linkPorts( "burner.Fl_O",  "HPT.Fl_I",      "station4"  );
linkPorts( "HPT.Fl_O",     "powerT.Fl_I",   "station5"  );
linkPorts("powerT.Fl_O", "nozzle.Fl_I", "station7");
linkPorts( "nozzle.Fl_O",  "end.Fl_I",      "station9"  );
linkPorts("propStart.Fl_O", "prop.Fl_I", "station500");
linkPorts("prop.Fl_O", "propStop.Fl_I", "station 501");

linkPorts( "HPC.Sh_O",     "shaft.HPClink", "HPCwork"   );
linkPorts( "HPT.Sh_O",     "shaft.HPTlink", "HPTwork"   );
linkPorts("powerT.Sh_O", "powerShaft.powerTlink", "powerTwork");
linkPorts("generator.Sh_O", "powerShaft.genlink", "genWork");
linkPorts("motor.Sh_O", "propShaft.motorlink", "motorlinksdkf");
linkPorts("prop.Sh_O", "propShaft.proplink", "proplinklskjf");

linkportI("generator.EP_O", "En.EP_I");
linkportI("En.EP_O", "motor.EP_I");

#include <EX7.view_page>


// set the model to DESIGN mode to run the turbojet DESIGN point
setOption( "switchDes", "DESIGN" );
autoSolverSetup();

Dependent pwr_balance{
   eq_lhs = "motor.Pout * motor.Eff";
   eq_rhs = "generator.Pout";
}
Dependent speed_balance{
   eq_lhs = "motor.Speed";
   eq_rhs = "generator.Speed";
}

solver.addIndependent("shaft.ind_Nmech");
solver.addDependent("pwr_balance");
solver.addDependent("speed_balance"); 

// cout << solver.list("Independent", TRUE) << endl;
// cout << solver.list("Dependent", TRUE) << endl;

// execute the DESIGN point
run();
page.display();


// output some variables of interest
// cout << "turbojet gross thrust = " << nozzle.Fg << " " << nozzle.Fg.units << endl;
// cout << "turbojet ram drag     = " << inlet.Fram << " " << inlet.Fram.units << endl;
// cout << "turbojet net thrust = " << nozzle.Fg - inlet.Fram << " " << nozzle.Fg.units << endl;
// cout << "turbojet fuel flow = " << burner.Wfuel << " " << burner.Wfuel.units << endl;
// cout << "burner exit temperature = " << burner.Fl_O.Tt << " " << burner.Fl_O.Tt.units << endl;
// cout << endl;


//---------------------------------------------------------------------------
//   EXERCISE 7: SET THE MODEL TO OFF-DESIGN MODE AND RUN CASES
//---------------------------------------------------------------------------

Independent ind_engineFAR { 
   varName = "burner.FAR";
} 

Dependent dep_HPCspeed { 
   eq_lhs = "HPC.S_map.NcMap";
   eq_rhs = "1.00";
} 


setOption( "switchDes", "OFFDESIGN" );
autoSolverSetup();

// make the above Independents and Dependents active
solver.addIndependent( "ind_engineFAR" );
solver.addDependent( "dep_HPCspeed" );


run();
page.display();

// case 1: flight Mach 0.00, altitude 0 ft
ambient.MN_in = 0.00;
ambient.alt_in = 0.;
run();
page.display();

// case 2: flight Mach 0.40, altitude 10000 ft
ambient.MN_in = 0.40;
ambient.alt_in = 10000.;
run();
page.display();

// case 3: flight Mach 0.80, altitude 25000 ft
ambient.MN_in = 0.80;
ambient.alt_in = 25000.;
run();
page.display();


