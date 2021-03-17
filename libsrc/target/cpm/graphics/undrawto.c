/*
 *	CP/M GSX based graphics libraries
 *
 *	undrawto(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: undrawto.c $
 */

#include <cpm.h>
#include <graphics.h>


void undrawto(int x,int y)
{
	gios_wmode(W_ERASE);
	gios_undrawto(48*x,128*(255-y));
	gios_wmode(W_REPLACE);
}
