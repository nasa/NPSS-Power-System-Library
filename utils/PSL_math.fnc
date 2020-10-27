/***
 -------------------------------------------------------------------------------
 |                                                                             |
 | NASA Glenn Research Center                                                  |
 | 21000 Brookpark Rd 		                                                   |
 | Cleveland, OH 44135 	                                                       |
 |                                                                             |
 | File Name:     Source.int										           |
 | Author(s):     George Thomas, Brian Malone                                  |
 | Date(s):       October 2020                                                 |
 |                                                                             |
 -------------------------------------------------------------------------------
***/

#ifndef __PSLMATH__
#define __PSLMATH__

real SIGMOID_TUNING_PARAMETER = 1000;

real sigmoid (real x)
{
    return (2*1/(1+E**(-SIGMOID_TUNING_PARAMETER * x))-1);
}

real sign (real x)
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
#endif
