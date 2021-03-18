/*
 *	CP/M GSX based graphics libraries
 *
 *	xordrawb(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: xordrawb.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ xordrawb(int tlx, int tly, int width, int height) __smallc;


void xordrawb(int x1,int y1,int x2,int y2)
{
	gios_wmode(W_COMPLEMENT);
	gios_drawb(48*x1,128*(255-y1),x2,128*(255-y2));
	gios_wmode(W_REPLACE);
}
