
#include <rex/rex.h>
#include <rex/WHmath.h>

#define pio2           1.57079633

/*
	atan2 discovers what quadrant the angle
	is in and calls atan.
*/

double
WHatan2(double arg1,double arg2)
{
 	if((arg1+arg2)==arg1)
		if(arg1 >= 0.0) return(pio2);
		else return(-pio2);
	else if(arg2 <0.0)
		if(arg1 >= 0.0)
			return(pio2+pio2 - satan(-arg1/arg2));
		else
			return(-pio2-pio2 + satan(arg1/arg2));
	else if(arg1>0.0)
		return(satan(arg1/arg2));
	else
		return(-satan(-arg1/arg2));
}
