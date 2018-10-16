
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
"baseline.run," you should get an output that looks like this:

=======================================
 Example Model with Real and Reactive Power
=======================================
*************************************************
Date:10/16/18    Time:16:17:47    Model:

TURBOMACHINERY PERFORMANCE DATA
               Wc      PR      eff         Nc       TR   efPoly        pwr     SMN     SMW
Prop       439.47   1.400   0.9300   4000.000   1.1085   0.9333    -8399.5   14.34   12.74
Turb        30.27   1.101   0.9000     85.280   1.0207   0.8990     9158.4



            EP_I.S.r  EP_I.V.mag  EP_I.V.phase  EP_I.I.mag  EP_I.I.phase        Mass      Loss_r      Loss_j
EM1         6524.492    1697.083    -8.23E-003    5150.417    -9.16E-005     481.809     271.854       0.000


                EP_I.S.r    EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j
Cable2a         1639.270    1635.927    1697.059    -3.53E-003    1287.605    -4.40E-004     644.099       0.000       0.000
Cable2b         4916.487    4906.451    1697.059    -3.53E-003    3862.812     2.47E-005     644.099       0.000       0.000
Cable3          6542.378    6524.492    1697.083    -8.23E-003    5150.417    -9.16E-005     858.799       0.000       0.000


                EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j
Gen1            1639.270    1697.056         0.000    1287.605    -4.40E-004     126.098      68.303       0.000
Gen2            4916.487    1697.056         0.000    3862.812     2.47E-005     378.191     204.854       0.000





Turbine PR 1.10112 Nozzle Thrust 11589
*************************************************
Date:10/16/18    Time:16:17:47    Model:

TURBOMACHINERY PERFORMANCE DATA
               Wc      PR      eff         Nc       TR   efPoly        pwr     SMN     SMW
Prop       402.97   1.319   0.9600   3600.000   1.0858   0.9615    -6084.9   19.03   14.28
Turb        30.27   1.067   0.8974     80.581   1.0138   0.8968     6165.3



            EP_I.S.r  EP_I.V.mag  EP_I.V.phase  EP_I.I.mag  EP_I.I.phase        Mass      Loss_r      Loss_j
EM1         4582.082    1697.063    -5.77E-003    3611.913    -9.16E-005     481.809     133.698       0.000


                EP_I.S.r    EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j
Cable2a         1149.596    1147.952    1697.056    -2.47E-003     902.979    -4.40E-004     644.099       0.000       0.000
Cable2b         3447.861    3442.925    1697.056    -2.47E-003    2708.934     2.47E-005     644.099       0.000       0.000
Cable3          4590.878    4582.082    1697.063    -5.77E-003    3611.913    -9.16E-005     858.799       0.000       0.000


                EP_O.S.r  EP_O.V.mag  EP_O.V.phase  EP_O.I.mag  EP_O.I.phase        Mass      Loss_r      Loss_j
Gen1            1149.596    1697.056         0.000     902.979    -4.40E-004     126.098       0.000       0.000
Gen2            3447.861    1697.056         0.000    2708.934     2.47E-005     378.191       0.000       0.000


