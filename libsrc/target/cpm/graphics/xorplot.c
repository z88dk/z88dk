/*
 *	CP/M GSX based graphics libraries
 *
 *	xorplot(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: xorplot.c $
 */

#include <cpm.h>
#include <graphics.h>


void xorplot(int x, int y)
{
	gios_wmode(W_COMPLEMENT);
	gios_plot(48*x,128*(255-y));
	gios_wmode(W_REPLACE);
}
