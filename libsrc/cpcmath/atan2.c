#include <stdio.h>
#include <math.h>
#include <float.h>

extern double __LIB__ halfpi();

/*	arc tangent of y/x  */
double atan2(y,x)
double x, y ;
{
	double a;

	if (fabs(x) >= fabs(y)) {
		a = atan(y/x) ;
		if (x < 0.0) {
			if (y >= 0.0) a += pi() ;
			else a -= pi() ;
		}
	}
	else {
		a = -atan(x/y) ;
		if (y < 0.0) a -= halfpi() ;
		else     a += halfpi() ;
	}
	return a ;
}
