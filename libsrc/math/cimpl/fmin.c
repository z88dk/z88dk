/*
 *	CPC Maths Routines
 *
 *  	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
 *
 *	$Id: fmin.c,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
 */
 

#include <float.h>
#include <math.h>


float fmin(float x,float y)
{
	if ( x < y )
		return x;
	return y;
}
