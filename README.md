
###########################################################################
#
# NPSS Power System Library
# NASA Glenn Research Center
#
###########################################################################

This repository contains a power system library for NPSS, containing
circuit components such as resistors and capacitors, electric machines,
and ports that are used to link them together. The library also includes
bus components that allow more than two elements to be connected to a
single node. Several examples are included in the library to demonstrate
the use of the various components, and how they may be connected to an
NPSS gas-turbine engine model.

To run the examples, first, open a command prompt or terminal with your
NPSS environment set up. Then, change directory to the main directory
of the project (containing "model," "src," "view," etc), and then run

>> runnpss -I model -I run -I src -I view [example run file]

to run any of the included models. If you run the baseline example,
"baseline.run," you should get an output that looks like this in the 
file "engine.viewOut":


************************************************************************************************************************************
Date:03/11/19    Time:13:09:14    Model:                                                                    converge = 1   CASE:   0 
Version:          NPSS_2.7.1          Gas Package: GasTbl        iter/pass/Jacb/Broy= 33/ 39/ 2/30        Run by:             jcsank 

                                        FLOW STATION DATA                                                                               
                                W        Pt        Tt       ht     FAR       Wc        Ps        Ts      rhos     Aphy      MN      gamt
St0-St1   Atm.Fl_O         219.74    14.696    518.67   123.95  0.0000   219.74     0.000      0.00  0.000000      0.0  0.0000   1.40052
St1-St2   Prop.Fl_O        219.74    20.574    574.97   137.46  0.0000   165.25     0.000      0.00  0.000000      0.0  0.0000   1.39944
St00-St10 TurbineAtm.Fl>   500.00   500.000   2200.00   574.10  0.0200    30.27     0.000      0.00  0.000000      0.0  0.0000   1.30774
St10-End0 Turb.Fl_O        500.00   476.730   2177.87   567.66  0.0200    31.58     0.000      0.00  0.000000      0.0  0.0000   1.30837
St2-End   Noz.Fl_O         219.74    20.574    574.97   137.46  0.0000   165.25    14.000    515.05  0.073366    508.3  0.7625   1.39944

                          ELECTRICAL POWER SYSTEM                                                                           
            EP_I.S.r  EP_I.V.mag  EP_I.V.phase  EP_I.I.mag  EP_I.I.phase        Mass      Loss_r      Loss_j                
EM1         3262.246    1202.595    -4.20E-002    1570.296    -4.93E-001     240.904     135.927    1579.978                
                                                                                                                            
                                                                                                                            
                                                                                                                            
                EP_I.S.r    EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j
Cable1          3262.278    3262.246    1202.595    -4.20E-002    1570.296    -4.93E-001     785.510       0.000       0.000
                                                                                                                            
                                                                                                                            
                                                                                                                            
 Generators                                                                                                                 
                EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j            
Gen1            3262.278    1200.000         0.000    1570.296    -4.93E-001     250.944     135.928       0.000            
                                                                                                                            





************************************************************************************************************************************
Date:03/11/19    Time:13:09:14    Model:                                                                    converge = 1   CASE:   0 
Version:          NPSS_2.7.1          Gas Package: GasTbl        iter/pass/Jacb/Broy= 18/ 36/ 3/14        Run by:             jcsank 

                                        FLOW STATION DATA                                                                               
                                W        Pt        Tt       ht     FAR       Wc        Ps        Ts      rhos     Aphy      MN      gamt
St0-St1   Atm.Fl_O         201.49    14.696    518.67   123.95  0.0000   201.48     0.000      0.00  0.000000      0.0  0.0000   1.40052
St1-St2   Prop.Fl_O        201.49    19.382    563.16   134.62  0.0000   159.19     0.000      0.00  0.000000      0.0  0.0000   1.39966
St00-St10 TurbineAtm.Fl>   500.00   500.000   2200.00   574.10  0.0200    30.27     0.000      0.00  0.000000      0.0  0.0000   1.30774
St10-End0 Turb.Fl_O        500.00   484.175   2185.08   569.76  0.0200    31.15     0.000      0.00  0.000000      0.0  0.0000   1.30816
St2-End   Noz.Fl_O         201.49    19.382    563.16   134.62  0.0000   159.19    14.000    513.14  0.073639    508.3  0.6978   1.39966

                          ELECTRICAL POWER SYSTEM                                                                           
            EP_I.S.r  EP_I.V.mag  EP_I.V.phase  EP_I.I.mag  EP_I.I.phase        Mass      Loss_r      Loss_j                
EM1         2291.127    1202.045    -2.95E-002    1103.348    -4.81E-001     240.904      67.107    1109.643                
                                                                                                                            
                                                                                                                            
                                                                                                                            
                EP_I.S.r    EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j
Cable1          2291.143    2291.127    1202.045    -2.95E-002    1103.348    -4.81E-001     785.510       0.000       0.000
                                                                                                                            
                                                                                                                            
                                                                                                                            
 Generators                                                                                                                 
                EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j            
Gen1            2291.143    1200.000         0.000    1103.348    -4.81E-001     250.944       0.000       0.000            
                                                                                                                   