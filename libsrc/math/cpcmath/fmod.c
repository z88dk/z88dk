/*
 *	CPC Maths Routines
 *
 *  	August 2003 **_|warp6|_** <kbaccam /at/ free.fr>
 *
 *	$Id: fmod.c,v 1.1 2008-07-27 21:44:56 aralbrec Exp $
 */
 

#include <float.h>
#include <math.h>


float fmod(float x,float y)
{
	return x - floor(x/y)*y;
}
