/*
 *	CP/M GSX based graphics libraries
 *
 *	xordraw(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: xordraw.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ xordraw(int x1, int y1, int x2, int y2) __smallc;

void xordraw(int x1,int y1,int x2,int y2)
{
	gios_wmode(W_COMPLEMENT);
	gios_draw(48*x1,128*(255-y1),x2,128*(255-y2));
	gios_wmode(W_REPLACE);
}
