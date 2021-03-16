/*
 *	CP/M GSX based graphics libraries
 *
 *	unplot(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: unplot.c $
 */

#include <cpm.h>
#include <graphics.h>


void unplot(int x, int y)
{
	gios_wmode(W_ERASE);
	gios_plot(48*x,128*(255-y));
	gios_wmode(W_REPLACE);
}
