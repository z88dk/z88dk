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


void drawb(int x1,int y1,int x2,int y2)
{
	gios_drawb(48*x1,128*(255-y1),x2,128*(255-y2));
}
