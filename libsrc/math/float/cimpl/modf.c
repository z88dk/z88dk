
#include <math.h>

extern double __LIB__ modf(double v, double *i);

double modf(double v, double *i)
{
    if ( v < 0 )
        return v - (*i = ceil(v));
    return v - (*i = floor(v));
}


