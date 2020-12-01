# NPSS - Power System Library

## NASA - Glenn Research Center

## Introduction

This repository contains a power system library (PSL) for the Numerical
Propulsion System Simulation (NPSS) software framework.
It contains circuit components such as resistors and capacitors, electric
machines, and ports that are used to link them together.
The library also includes bus components that allow more than two elements to be
connected to a single node.

Several examples are included in the library to demonstrate the use of the
various components, and how they may be connected to an NPSS gas-turbine engine
model.

## Usage

If you have your NPSS environment set up, you can run a model like so:

```bat
runnpss-psl run\[file_name].run
```

> NOTE: You must run this command from the project root
directory (containing "src", "model", etc).

## Example

If you run the baseline example, "baseline.run," you should get an output that
looks like this in the file "engine.viewOut":

```txt
*******************************************************************************                                                                 
NCP                   NPSS_2.7.1    model:         Baseline   run by:     glthoma1   solutionMode= STEADY_STATE     converge=    1    CASE:    0
time:  0.0000   timeStep:0.05000    therm_package:   GasTbl   Mode:         DESIGN   itr/pas/Jac/Bry=  15/  20/  1/ 13    run: 12/01/20 12:33:00

                                        FLOW STATION DATA                                                                               
                                W        Pt        Tt       ht     FAR       Wc        Ps        Ts      rhos     Aphy      MN      gamt
St0-St1   Atm.Fl_O         219.74    14.696    518.67   123.95  0.0000   219.74     0.000      0.00  0.000000      0.0  0.0000   1.40052
St1-St2   Prop.Fl_O        219.74    20.574    574.97   137.46  0.0000   165.25     0.000      0.00  0.000000      0.0  0.0000   1.39944
St00-St10 TurbineAtm.Fl>   500.00   500.000   2200.00   574.10  0.0200    30.27     0.000      0.00  0.000000      0.0  0.0000   1.30774
St10-End0 Turb.Fl_O        500.00   476.711   2177.85   567.66  0.0200    31.58     0.000      0.00  0.000000      0.0  0.0000   1.30837
St2-End   Noz.Fl_O         219.74    20.574    574.97   137.46  0.0000   165.25    14.000    515.05  0.073366    508.3  0.7625   1.39944

                                        ELECTRICAL PORT DATA                                          
                                   Complex Power Data           |               Misc Data             
             |S|, kVA  /_S, deg    P, kW  Q, kVAR     Power Type  Power Factor  frequency, Hz         
Gen1.EP_O     3332.51    11.567  3264.83   668.19            AC3        0.9797        400.000         
Cable1.EP_I   3332.51    11.567  3264.83   668.19            AC3        0.9797        400.000         
Cable1.EP_O   3328.84    11.478  3262.27   662.43            AC3        0.9800        400.000         
EM1.EP_I      3328.84    11.478  3262.27   662.43            AC3        0.9800        400.000         
                                                                                                      
                                   Complex Voltage Data  (V_LL)   |     Complex Current Data  (I_Line)
                 |V|, V  /_V, deg      V.r      V.j      |I|, A  /_I, deg      I.r      I.j           
Gen1.EP_O       1200.00     0.000  1200.00     0.00     1603.35   -41.567  1199.61  ----.--           
Cable1.EP_I     1200.00     0.000  1200.00     0.00     1603.35   -41.567  1199.61  ----.--           
Cable1.EP_O     1198.68    -0.088  1198.68    -1.85     1603.35   -41.567  1199.61  ----.--           
EM1.EP_I        1198.68    -0.088  1198.68    -1.85     1603.35   -41.567  1199.61  ----.--           

                                        ELECTRICAL POWER SYSTEM COMPONENT DATA  
            eff  Mass, kg  Loss_r, kW  Loss_j, kVAR  Q_heat, BTU/s              
Gen1    1.00000    251.14      136.03          0.00         128.94              
Cable1  0.99921    452.55        2.57          5.76           5.98              
EM1     1.00000    240.91      130.49        662.43         639.93              
                                                                                
                            ELECTRICAL POWER SYSTEM -- COMPONENT SPECIFIC DATA  
                                                                                
AeroCable Data                                                                  
           R, Ohms  L, Henries  X, Reactance  cable_size   #parallel    ampacity
Cable1   3.33E-004   2.97E-007     7.47E-004         2/0       6.000    1608.000
```
For more information, see the NPSS Power System Library [wiki page](../../wiki/Home/).
