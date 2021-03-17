/*
 *	CP/M GSX based graphics libraries
 *
 *	undrawr(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: undrawr.c $
 */

#include <cpm.h>
#include <graphics.h>


void undrawr(int x,int y)
{
	gios_wmode(W_ERASE);
	gios_undrawr(48*x,128*(255-y));
	gios_wmode(W_REPLACE);
}
