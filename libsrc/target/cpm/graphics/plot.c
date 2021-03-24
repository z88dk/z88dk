/*
 *	CP/M GSX based graphics libraries
 *
 *	plot(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: plot.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ plot(int x, int y) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void plot(int x, int y)
{
	gios_plot(gsx_xscale(x),gsx_yscale(y));
}
