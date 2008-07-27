#include <stdio.h>
#include <math.h>
#include "float.h"

double tanh(double x)
{
	double e;

	e = exp(x) ;
	return (e-1.0/e)/(e+1.0/e) ;
}
