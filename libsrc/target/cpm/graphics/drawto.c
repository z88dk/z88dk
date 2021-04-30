/*
 *	CP/M GSX based graphics libraries
 *
 *	drawto(x,y)
 *
 *	Stefano Bodrato - March 2021
 *
 *	$Id: drawto.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ drawto(int x2, int y2) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void drawto(int x,int y)
{
	gios_drawto(gsx_xscale(x),gsx_yscale(y));
}

