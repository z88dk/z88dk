/*
 *	CPC Maths Routines
 *
 *  	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
 *
 *	$Id: amin.c,v 1.1 2003-08-30 16:42:48 dom Exp $
 */
 

#include <float.h>
#include <math.h>


float amin(float x,float y)
{
	if ( x < y )
		return x;
	return y;
}
