
#include <rex/rex.h>
#include <rex/WHmath.h>

/*
	atan makes its argument positive and
	calls the inner routine satan.
*/

double WHatan(double arg)
{

        if(arg>0.0)
		return(satan(arg));
	else
		return(-satan(-arg));
}
