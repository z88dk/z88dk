/*
 * ceil()
 */
 

#include <float.h>
#include <math.h>


float ceil(float x)
{
    if ( x < 0 ) {
        return floor(x) + 1.0;
    }
    if ( x > 0 ) {
        return floor(x) + 1.0;
    }
    return 0.0;
}
