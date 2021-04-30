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
//#include <graphics.h>
extern void __LIB__ xorplot(int x, int y) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void xorplot(int x, int y)
{
	gios_wmode(W_COMPLEMENT);
	gios_plot(gsx_xscale(x),gsx_yscale(y));
	gios_wmode(W_REPLACE);
}
