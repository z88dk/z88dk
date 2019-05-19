/*
 *	asin(x)
 */

#include <float.h>
#include <math.h>


double asinh(double x)
{
	return log(2.*fabs(x)+1./(sqrt(x*x+1.)+fabs(x)));
}
