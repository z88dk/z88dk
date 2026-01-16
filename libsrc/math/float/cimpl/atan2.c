#include <stdio.h>
#include <math.h>
#include <float.h>


/*	arc tangent of y/x  */
double atan2(y,x)
double x, y ;
{
	double a;

	if (fabs(x) >= fabs(y)) {
		a = atan(y/x) ;
		if (x < 0.0) {
			if (y >= 0.0) a += M_PI ;
			else a -= M_PI ;
		}
	}
	else {
		a = -atan(x/y) ;
		if (y < 0.0) a -= (M_PI / 2.0) ;
		else     a += (M_PI / 2.0);
	}
	return a ;
}
