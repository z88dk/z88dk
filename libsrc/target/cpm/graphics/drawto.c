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


void drawto(int x,int y)
{
	gios_drawto(48*x,128*(255-y));
}

