
#ifndef __MOTOR__
#define __MOTOR__

#include <InterpIncludes.ncp>

class Generator extends Element{
    //------------------------------------------------------------
    //     ******* DOCUMENTATION *******
    //------------------------------------------------------------

    title = "";

    description = isA() + "models an electric generator that is connected to a single shaft.";

    usageNotes = isA() + 
    "
    
    -This element models an electric generator connecting to one shaft and producing a weight.
    The weight is computed using the power into the generator at design, based on a regression line
    generated from actual motors. The subset of motors used to generate this regression line is 
    determined by the keywords specified in the option variables. If no options are specified, 
    the weight will be calculated based on all the available motors combined into a single regression
    line.
    
    -At off design, it is likely that the solver will require additional independendents and dependents
    if the complexity of the model is high. A good pair to add for a turboshaft engine is to vary the
    generator power (independent) and force the corresponding power turbine to operate at its DESIGN 
    corrected speed.
    ";

    background = "";

    //------------------------------------------------------------
    //     ******* SETUP VARIABLES ********
    //------------------------------------------------------------

    real eff{
        value = 1.;  IOstatus = INPUT;  units = NONE;
        description = "efficiency of the motor";
    }
    real KWpwr{
        value = 1.;  IOstatus = OUTPUT;  units = KW;
        description = "power the generator is designed to handle in metric units";
    }
    real N{
        value = 1.;  IOstatus = OUTPUT;  units = RPM;
        description = "Speed of incoming shaft";
    }
    real pwrDes{
        value = 1.;  IOstatus = OUTPUT;  units = HORSEPOWER;
        description = "power the generator is designed to handle";
    }
    real pwrIn{
        value = 1.;  IOstatus = INPUT;  units = HORSEPOWER;
        description = "power from shaft";
    }
    real pwrOut{
        value = 1.;  IOstatus = OUTPUT;  units = HORSEPOWER;
        description = "power out of generator";
    }
    real trq{
        value = 1.;  IOstatus = OUTPUT;  units = FT_LBF;
        description = "Torque coming from turbine";
    }
    real weight{
        value = 1.;  IOstatus = OUTPUT;  units = KG;
        description = "Weight of electric motor";
    }
    
    //------------------------------------------------------------
    //   ******* OPTION VARIABLE SETUP *******
    //------------------------------------------------------------
    Option switchDes{
        allowedValues = {DESIGN, OFFDESIGN};
        description = "Determines if the element is in design or off-design mode";
        IOstatus = INPUT;
        rewritableValues = FALSE;
    }
    Option switchDir{
        allowedValues = {NONE, "AXIAL", "RADIAL"};
        description = "Determines the direction of magnetic flux in the motor";
        IOstatus = INPUT;
        rewritableValues = FALSE;
    }
    Option switchCool{
        allowedValues = {NONE, "AIRCOOL", "LIQUIDCOOL"};
        description = "Determines the type of cooling used in the motor";
        IOstatus = INPUT;
        rewritableValues = FALSE;
    }
    Option switchRun{
        allowedValues = {NONE, "INRUNNER", "OUTRUNNER"};
        description = "Determines whether the motor has an exterior or interior stator, only valid for radial motors";
        IOstatus = INPUT;
        rewritableValues = FALSE;
    }

    //------------------------------------------------------------
    // ****** SETUP PORTS, FLOW STATIONS, SOCKETS, TABLES ********
    //------------------------------------------------------------

    // FLUID PORTS

    // FUEL PORTS
    
    // BLEED PORTS

    // THERMAL PORTS

    // MECHANICAL PORTS

    ShaftOutputPort Sh_O{
        description = "Output to Shaft";
    }

    // FLOW STATIONS

    // SOCKETS

    //TABLES

    //------------------------------------------------------------
    // ******* INTERNAL SOLVER SETUP *******
    //------------------------------------------------------------

    //------------------------------------------------------------
    //  ******  ADD SOLVER INDEPENDENTS & DEPENDENTS  ******
    //------------------------------------------------------------

    //------------------------------------------------------------
    // ******* VARIABLE CHANGED METHODOLOGY *******
    //------------------------------------------------------------

    void variableChanged(string name, any oldVal){

        if(name == "switchDes"){

            if(switchDes == "DESIGN"){
                pwrDes = pwrIn;
            }
        }

    }

    //------------------------------------------------------------
    //   ******* PERFORM ENGINEERING CALCULATIONS *******
    //------------------------------------------------------------
    void calculate(){

        //------------------------------------------------------------
        //   ******* PERFORM ENGINEERING CALCULATIONS *******
        //------------------------------------------------------------
        N = Sh_O.Nmech;
        trq = C_HP_PER_RPMtoFT_LBF * pwrIn / N;
        Sh_O.trq = trq;
        
        KWpwr = -pwrDes / 1.341;
        pwrOut = pwrIn * eff;

        if(switchDir == "AXIAL"){
            if(switchCool == "AIRCOOL"){
                weight = .217694 * KWpwr + .875470;
            }
            else if(switchCool == "LIQUIDCOOL"){
                weight = .161237 * KWpwr + 3.18910;
            }
            else{
                weight = .1796161 * KWpwr + 2.06154;
            }
        }

        else if(switchDir == "RADIAL"){
            if(switchRun == "INRUNNER"){
                if(switchCool == "AIRCOOL"){
                    weight = .209385 * KWpwr + 1.22402;
                }
                else if(switchCool == "LIQUIDCOOL"){
                    weight = .118154 * KWpwr + 20.1903;
                }
                else{
                    weight = .205208 * KWpwr + 3.75817;
                }
            }
            else if(switchRun == "OUTRUNNER"){
                if(switchCool == "AIRCOOL"){
                    weight = .107436 * KWpwr + 4.45283;
                }
                else if(switchCool == "LIQUIDCOOL"){
                    weight = .101150 * KWpwr + 34.9063;
                }
                else{
                    weight = .219892 * KWpwr + 2.41494;
                }
            }
            else{
                if(switchCool == "AIRCOOL"){
                    weight = .204565 * KWpwr + .601602;
                }
                else if(switchCool == "LIQUIDCOOL"){
                    weight = .151301 * KWpwr + 22.5111;
                }
                else{
                    weight = .208337 * KWpwr + 3.36047;
                }
            }
        }
        else{
            if(switchRun == "INRUNNER"){
                if(switchCool == "AIRCOOL"){
                    weight = .209385 * KWpwr + 1.22402;
                }
                else if(switchCool == "LIQUIDCOOL"){
                    weight = .118154 * KWpwr + 20.1903; 
                }
                else{
                    weight = .205028 * KWpwr + 3.75817;
                }
            }
            else if(switchRun == "OUTRUNNER"){
                if(switchCool == "AIRCOOL"){
                    weight = .151252 * KWpwr + 3.46804;
                }
                else if(switchCool == "LIQUIDCOOL"){
                    weight = .215053 * KWpwr + 6.74532;
                }
                else{
                    weight = .216875 * KWpwr + 2.15106;
                }
            }
            else{
                if(switchCool == "AIRCOOL"){
                    weight = KWpwr * .204654 + .840730;
                }
                else if(switchCool == "LIQUIDCOOL"){
                    weight = KWpwr * .180591 + 9.84733;
                }
                else{
                    weight = KWpwr * .206554 + 2.38061;
                }
            }
        }

    }

}


