/* Dummy scientific format converter */

#include <float.h>

void ftoe(double number, int prec, char *str)
{
        ftoa(number,prec,str);
}

