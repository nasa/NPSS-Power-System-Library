/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                   |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     TestingUtils.fnc                                             |
 | Author(s):	  Michael Stich                                                |
 | Date(s):       April 2023                                                   |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

#ifndef _TESTING_UTILS_
#define _TESTING_UTILS_

void testParameterDifference(string name, string type, real errTol, real theo, real calc) {
    if (abs(theo - calc) > errTol) {
        cerr << endl << "[ERROR]: " << type << " parameter of " << name << 
        " is not equal to calculated value. " << endl;
        cerr << type << " = " << theo << endl;
        cerr << type <<" Calculated = " << calc << endl;
        cerr << "Percent Difference = " << (((theo - calc)/theo)*100) << endl << endl;
    }
}

void testCurrentDifference(string name, real errTol, real Real, real Imag) {
    if ((abs(Real) + abs(Imag)) > errTol) {
        cerr << endl << "[ERROR]: Real Input/Output current of " << name << 
        " does not match the Imaginary Input/Output current within the error tolerance." << endl;
        cerr << "Difference between Real Input & Output = " << Real << endl;
        cerr << "Difference between Imaginary Input & Output = " << Imag << endl;
        cerr << "Percent Difference = " << (((abs(Real) + abs(Imag))/abs(Real))*100) << endl << endl;
    }
}

#endif