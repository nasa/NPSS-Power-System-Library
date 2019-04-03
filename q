[33mcommit e1f646556d1e13b9249cb87e888604fc43a925ce[m[33m ([m[1;36mHEAD -> [m[1;32mmaster[m[33m)[m
Author: Bergeson <jbergeso@ndc.nasa.gov>
Date:   Tue Mar 26 17:02:47 2019 -0400

    made some minor tweaks to motor and generator, integrated map function and verified it is working

[33mcommit 6e7b81c31e68b0fb5b5487e8d9088ee682d97a12[m
Author: Bergeson <jbergeso@ndc.nasa.gov>
Date:   Tue Mar 26 13:53:52 2019 -0400

    Added a few inputs and outputs, cleaned up calculations and increased clarity, added map socket, added design variables

[33mcommit c59697bd2d07950e93424b0fddf932b83644242f[m
Author: Bergeson <jbergeso@ndc.nasa.gov>
Date:   Mon Mar 25 13:09:12 2019 -0400

    Added map socket

[33mcommit 39bfc82d8de8db1bafb0f5c9138a85fd9093723e[m[33m ([m[1;31morigin/master[m[33m, [m[1;31morigin/HEAD[m[33m)[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Wed Mar 20 15:09:15 2019 -0400

    BUG - identified that the refport was copying frequently incorrectly and overwrote the frequency.  Not a problem when frequency was the same all the time.  Switched around and works correctly now.

[33mcommit 4210425a858c36a9ee7be7a6fe457a3d4ccad10b[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Thu Mar 14 12:38:10 2019 -0400

     updated examples to use random numbers for electrical components.

[33mcommit 0c201f9ce77637ae647ef91454e1b1b3f96782c6[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Mar 11 13:19:09 2019 -0400

    Clean up model header files.

[33mcommit ca60237c87866445d2acdae76d93c7c59d629363[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Mar 5 14:24:59 2019 -0500

    modified run and model files to have same consistent header.

[33mcommit 7cf6f147a302a44af8f9a394a09ff0df32ef4bc6[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Mar 5 14:20:59 2019 -0500

    Updated run and model files to be consistent with the other examples

[33mcommit 19ce7b1a136f4658a7b2571fc31cc6318553918b[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Mar 5 14:15:42 2019 -0500

    Modified model/run files to have consistent header.

[33mcommit 9d51feba38c6bd885152591abdaeb07e1a8b712d[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Mar 5 14:11:09 2019 -0500

    Removed sink from source code and used AC source to complete circuit.  Modified run file to have generic NPSS header comment.

[33mcommit 0c861322342cf608098095f2c449a3cffe599036[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Mar 5 14:09:26 2019 -0500

    Removed bus since it has been replaced with a node.

[33mcommit 4b673df586099bcb32b190d566433515e9db5b3a[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Mar 4 13:17:55 2019 -0500

    Updated models to account for change in cable scaling.

[33mcommit 40adf034042afbe96827ee8ed532d38cec13f635[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Mar 4 13:09:27 2019 -0500

    Modified 3 phase example to use generic cable element rather than specialized 3 phase components.

[33mcommit 7c40cefa8b85a015d48c98d7baa194a6c3dc1323[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Fri Feb 15 10:39:37 2019 -0500

    Updated viewers to report magnitude and phase (degrees) instead of complex conjugate.

[33mcommit 91f3abd257212ee9809572306db4c4175815b365[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Fri Feb 15 07:45:46 2019 -0500

    Added 3 phase data into the viewer files.

[33mcommit f01e91585c95ca18926ad1e08a9ac8b1fe98eb26[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Fri Feb 15 07:34:34 2019 -0500

     Added VLN to both AC1 and AC3 (to make calculations in the elements simplier and remove unnecessary scaling in the port/elements. Added a three phase cable and Y-connected load.

[33mcommit 86a6077f1d3091d073286ee74e5c824e458d0a73[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Wed Feb 13 15:49:15 2019 -0500

    BUG - 3 phase introduction.

[33mcommit 27c16480eebf23d74cc589a31b2acaa63b9a091e[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Wed Feb 13 15:47:28 2019 -0500

    Started modification to change variables to RMS instead of peak.

[33mcommit fb1b082f46e5fdaa054024b412a8cdd430f93f95[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Wed Feb 13 09:33:07 2019 -0500

    Modified sims to use S,V,and, I instead of Pdc, Vdc, Idc, and found bug in complex number, timesRMS.  Old code divdied by 0.5 and should have been square root of 2

[33mcommit 5e717ed1ef45997dd27e1977d436eb8e24803ae0[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Feb 12 11:37:10 2019 -0500

    Added power to output file and command window (via runtime viewer and .run files).

[33mcommit 05c0eaa57142044365febceb421492f8039b7865[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 11 15:18:26 2019 -0500

    Fixed bug associated with DC components and added DC example.

[33mcommit 44413ba03e2f16f30432ab11f63b81f926347f6b[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 11 13:03:41 2019 -0500

    Fixed bug related to setting data in degrees

[33mcommit b0ed06db831e15dee2b7e285ba5ea1b97569745f[m
Merge: 92f0b79 317089f
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 4 15:34:31 2019 -0500

    Merge branch 'master' of github.com:nasa/NPSS-Power-System-Library
    
    * 'master' of github.com:nasa/NPSS-Power-System-Library:
      Update readme so that the program output does not get formatted strangely
      Rename readme file to not have the .txt extension at the end.
      Add directions for running the model to the readme.
      Fix a few typos, correct voltage dependent descriptions.
      Added readme.

[33mcommit 92f0b795f1c08319c9edecc6a32703e9196079c2[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 4 15:14:17 2019 -0500

    Made corrections with viewer to add electrical components to output file and runtime output file.

[33mcommit 8328332f4f798c707a7bd95a14e1f637a0c53862[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 4 15:07:40 2019 -0500

    Added RLC example

[33mcommit 943296c5a79c812eeec1f85e81b3b6be9a2dd206[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 4 15:04:09 2019 -0500

    Updated example showing 2 bus to 1 example.

[33mcommit 998c0f7f5a91c1aa6da8e5cd4e9162953f51cf2a[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 4 15:03:18 2019 -0500

    Updated baseline example showing bus from 1 to 2.

[33mcommit 41de97ff14ad6db76235046d80ddc1f62c338068[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Feb 4 14:58:34 2019 -0500

    Updated changes with baseline model based on feedback from partners.

[33mcommit 317089fb2c01da2f397d38c2c3453ca824ec4d6a[m
Merge: c0120be a3c56cd
Author: jeffreycsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Oct 22 13:32:29 2018 -0400

    Merge pull request #1 from georgelthomas/master
    
    Improve readability

[33mcommit a3c56cd79954615fe5e834e8c0cc236a9a8ca1d0[m
Author: George Thomas <george.l.thomas@nasa.gov>
Date:   Tue Oct 16 16:31:20 2018 -0400

    Update readme so that the program output does not get formatted strangely

[33mcommit 9c398078a71e3defa9c847792d602e17a0c9b4f8[m
Author: Thomas <glthoma1@ndc.nasa.gov>
Date:   Tue Oct 16 16:28:00 2018 -0400

    Rename readme file to not have the .txt extension at the end.

[33mcommit 51fac4314da79a45c1ef3c2dd45af88ef1d82ee9[m
Author: Thomas <glthoma1@ndc.nasa.gov>
Date:   Tue Oct 16 16:24:01 2018 -0400

    Add directions for running the model to the readme.

[33mcommit 2952271a7ac7a17e310320228d5cd3541177128d[m
Author: Thomas <glthoma1@ndc.nasa.gov>
Date:   Tue Oct 16 14:44:18 2018 -0400

    Fix a few typos, correct voltage dependent descriptions.

[33mcommit 5d80ec322c2420f4608307bb5d8d1ddb1d108ccf[m
Author: Thomas <glthoma1@ndc.nasa.gov>
Date:   Tue Oct 16 14:14:56 2018 -0400

    Added readme.

[33mcommit c0120be45c688d7b5f4a8ab044e1c859a81be0b4[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Tue Oct 9 11:32:56 2018 -0400

    Added changes to have all systems use PQ equations and renamed all elements removing the e noting that they are electrical components.

[33mcommit bfc4574ffec76d1e4e445d712848d8888ab1d383[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Oct 1 15:20:44 2018 -0400

    Updated the complex/real power example using more generic equations and updated port

[33mcommit ec4fb635754ef85f7c0b6ccd3568e26c564079f6[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Oct 1 15:11:35 2018 -0400

    Updated files for the 2 to 1 bus example using complex power

[33mcommit 8b2d3a30c524bd284283887b6ec88dbee9f01e69[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Oct 1 15:09:53 2018 -0400

    Updated files for the 1 to 2 bus using complex power equations

[33mcommit caefdc99e8a8b6edbdd084006a5e7aed424a145e[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Mon Oct 1 14:57:31 2018 -0400

    Updated baseline.mdl and basic components for complex power and entered zero for imaginary component, basically allowing the components to provide the same output as the original baseline version (no complex power/imaginary power)

[33mcommit a148922faa9a797bb257e8ca3aa3cb83b2e08768[m[33m ([m[1;33mtag: v0.0.1[m[33m)[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Thu Sep 20 12:02:15 2018 -0400

    Added example that uses complex power (real and imaginary)

[33mcommit b7a4080345244697b943c2637cc2e25ba5b75405[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Thu Sep 20 11:59:27 2018 -0400

    Added example where you have 2 inputs (generators) feeding 1 output (motor)

[33mcommit 29504a4d1a4a72c6f1f79ac78434273c85a13ebf[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Thu Sep 20 11:58:17 2018 -0400

    Adde example that contains 1 bus input (generator) and feeds 2 outputs (motors)

[33mcommit 681a5aeb10f43cf37978bdb93c13fef0466961c7[m
Author: jeffcsank <jeffrey.t.csank@nasa.gov>
Date:   Thu Sep 20 11:32:12 2018 -0400

    Add electric port with simple 1 string electrical power system connected to a turbine and motor/fan
