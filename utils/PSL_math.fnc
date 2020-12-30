/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                   |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     PSL_math.fnc										           |
 | Author(s):     George Thomas, Brian Malone                                  |
 | Date(s):       October 2020                                                 |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

#ifndef __PSLMATH__
#define __PSLMATH__

real sign(real x)
{
    if (x < 0) //negative function input
    {
        return (-1);
    }
    else if (x > 0)
    {
        return (1);
    }
    else
    {
        return (0);
    }
}

// Create a sigmoidal function that represents a smooth version of the sign function
real SIGMOID_TUNING_PARAMETER = 1000;

real sigmoid(real x)
{
    return (2*1/(1+E**(-SIGMOID_TUNING_PARAMETER * x))-1);
}

#endif
