/*
 *	acos(x)
 *
 *	-1 < x < 1
 *
 *	Undefined results otherwise
 *
 *	$Id: acos.c,v 1.2 2002-01-21 20:35:21 dom Exp $
 */

#include <float.h>
#include <math.h>

extern double _halfpi;

double acos(double x)
{
	return ( _halfpi - asin(x) );
}
