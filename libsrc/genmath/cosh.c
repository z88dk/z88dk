#include <stdio.h>
#include <math.h>
#include "float.h"

double cosh(x)
double x;
{
	double e;

	e = exp(x) ;
	return 0.5*(e+1.0/e) ;
}
