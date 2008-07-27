/*
 *	acos(x)
 *
 *	-1 < x < 1
 *
 *	Undefined results otherwise
 *
 *	$Id: acos.c,v 1.1 2008-07-27 21:44:57 aralbrec Exp $
 */

#include <float.h>
#include <math.h>

extern double _halfpi;

double acos(double x)
{
	return ( _halfpi - asin(x) );
}
