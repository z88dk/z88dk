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
extern void __LIB__ clga(int tlx, int tly, int tlx2, int tly2) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void clga(int x1,int y1,int x2,int y2)
{
	int xa,ya,xb,yb;
	
	if (x1<x2) {
		xa=x1;
		xb=x2;
	} else {
		xa=x2;
		xb=x1;
	}

	if (y1<y2) {
		ya=y2;
		yb=y1;
	} else {
		ya=y1;
		yb=y2;
	}
	
	gios_wmode(W_ERASE);
	gios_f_style(F_FULL);

	gios_drawb(gsx_xscale(xa+2),gsx_yscale(ya+2),gsx_xscale(xb-2),gsx_yscale(yb-2));
	gios_update();

	gios_f_style(F_EMPTY);
	gios_wmode(W_REPLACE);
}
