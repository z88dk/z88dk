/*
 *	CP/M GSX based graphics libraries
 *
 *	xordrawto(x,y)
 *
 *	Stefano Bodrato - March 2021
 *
 *	$Id: xordrawto.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ xordrawto(int x2, int y2) __smallc;


void xordrawto(int x,int y)
{
	gios_wmode(W_COMPLEMENT);
	gios_drawto(48*x,128*(255-y));
	gios_wmode(W_REPLACE);
}

