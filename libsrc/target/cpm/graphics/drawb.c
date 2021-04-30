/*
 *	CP/M GSX based graphics libraries
 *
 *	drawb(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: drawb.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ drawb(int tlx, int tly, int width, int height) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;
extern int  __LIB__ gsx_xoffs(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yoffs(int y) __z88dk_fastcall;


void drawb(int x1,int y1,int x2,int y2)
{
		gios_plot(gsx_xscale(x1),gsx_yscale(y1));
		gios_drawr(gsx_xoffs(x2),0);
		gios_drawr(0,gsx_yoffs(y2));
		gios_drawr(gsx_xoffs(-x2),0);
		gios_drawr(0,-gsx_yoffs(y2));
}
