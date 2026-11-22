/*
 *	atanh(x)
 */

#include <float.h>
#include <math.h>


double atanh(double x)
{
	return (log((1.+x)/(1.-x))*.5);
}
