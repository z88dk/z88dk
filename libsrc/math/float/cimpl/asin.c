/*
 *	asin(x)
 *
 *	-1 < x < 1
 *
 *	Undefined results otherwise
 *
 *	$Id: asin.c,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
 */

#include <float.h>
#include <math.h>


double asin(double x)
{
	return atan(x/(sqrt(1.-(x*x))));
}
