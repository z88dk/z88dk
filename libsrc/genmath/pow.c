#include <stdio.h>
#include <math.h>

/*
 *	transcendental functions: pow
 */

double pow(x,y)	/* x to the power y */
double x,y;
{
	return exp(log(x)*y);
}
