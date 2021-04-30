/*
 *	CP/M GSX based graphics libraries
 *
 *	undraw(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: undraw.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ undraw(int x1, int y1, int x2, int y2) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void undraw(int x1,int y1,int x2,int y2)
{
	gios_wmode(W_ERASE);
	gios_draw(gsx_xscale(x1),gsx_yscale(y1),gsx_xscale(x2),gsx_yscale(y2));
	gios_wmode(W_REPLACE);
}
