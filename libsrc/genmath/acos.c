/*
 *	acos(x)
 *
 *	-1 < x < 1
 *
 *	Undefined results otherwise
 *
 *	$Id: acos.c,v 1.1 2002-01-20 18:41:41 dom Exp $
 */

#include <float.h>
#include <math.h>

extern	double halfpi;

double acos(double x)
{
	return ( halfpi - asin(x) );
}
