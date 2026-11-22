#include <stdio.h>
#include <math.h>

/*
 *	transcendental functions: pow
 */

double pow(x,y)	/* x to the power y */
double x,y;
{
	if (y == 0.0) return 1.0;
	if (y == 1.0 ) return x;
	if (x <= 0.0) return 0.0;
	return exp(log(x)*y);
}
