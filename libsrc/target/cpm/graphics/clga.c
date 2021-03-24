/*
 *	CP/M GSX based graphics libraries
 *
 *	clga(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: clga.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ clga(int tlx, int tly, int width, int height) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void clga(int x1,int y1,int x2,int y2)
{
	int y;
	gios_wmode(W_ERASE);
	for(y=y1;y<y2;y++)
		gios_draw(gsx_xscale(x1),gsx_yscale(y),gsx_xscale(x1+x2-1),gsx_yscale(y));
	gios_wmode(W_REPLACE);
}
