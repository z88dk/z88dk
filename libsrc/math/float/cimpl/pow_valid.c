#include <stdio.h>
#include <math.h>

/*
 *	transcendental functions: pow
 *
 *  	This version validates before calling the math
 *      library implementation
 */

extern double _pow_impl(double x, double y);

double pow(x,y)	/* x to the power y */
double x,y;
{
	if (y == 0.0) return 1.0;
	if (y == 1.0 ) return x;
	if (x <= 0.0) return 0.0;
	if (y == 2.0) return x * x;
	return _pow_impl(x,y);
}
