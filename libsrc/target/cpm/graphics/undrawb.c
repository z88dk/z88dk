/*
 *	CP/M GSX based graphics libraries
 *
 *	undrawb(x1,y1,x2,y2)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: undrawb.c $
 */

#include <enterprise.h>
//#include <graphics.h>
extern void __LIB__ undrawb(int tlx, int tly, int width, int height) __smallc;


void undrawb(int x1,int y1,int x2,int y2)
{
	gios_wmode(W_ERASE);
	gios_drawb(48*x1,128*(255-y1),x2,128*(255-y2));
	gios_wmode(W_REPLACE);
}
