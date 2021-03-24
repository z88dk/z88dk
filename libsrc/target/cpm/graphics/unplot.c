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
//#include <graphics.h>
extern void __LIB__ unplot(int x, int y) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void unplot(int x, int y)
{
	gios_wmode(W_ERASE);
	gios_plot(gsx_xscale(x),gsx_yscale(y));
	gios_wmode(W_REPLACE);
}
