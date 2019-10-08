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


double acos(double x)
{
	return ( (M_PI / 2.)  - asin(x) );
}
