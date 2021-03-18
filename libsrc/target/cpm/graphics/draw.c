/*
 *	CP/M GSX based graphics libraries
 *
 *	draw(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: draw.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ draw(int x1, int y1, int x2, int y2) __smallc;

void draw(int x1,int y1,int x2,int y2)
{
	gios_draw(48*x1,128*(255-y1),x2,128*(255-y2));
}
