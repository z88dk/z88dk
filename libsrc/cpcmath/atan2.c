#include <stdio.h>
#include <math.h>
#include "float.h"

extern double _pi;
extern double _halfpi;

/*	arc tangent of y/x  */
double atan2(y,x)
double x, y ;
{
	double a;

	if (fabs(x) >= fabs(y)) {
		a = atan(y/x) ;
		if (x < 0.0) {
			if (y >= 0.0) a += _pi ;
			else a -= _pi ;
		}
	}
	else {
		a = -atan(x/y) ;
		if (y < 0.0) a -= _halfpi ;
		else     a += _halfpi ;
	}
	return a ;
}
