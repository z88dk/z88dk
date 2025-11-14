/*
 *	acos(x)
 */

#include <float.h>
#include <math.h>


double acosh(double x)
{
	return log(2.*x-1./(x+sqrt(x*x-1.)));
}
