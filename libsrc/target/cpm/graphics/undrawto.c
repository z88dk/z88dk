/*
 *	CP/M GSX based graphics libraries
 *
 *	undrawto(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: undrawto.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ undrawto(int x2, int y2) __smallc;


void undrawto(int x,int y)
{
	gios_wmode(W_ERASE);
	gios_drawto(48*x,128*(255-y));
	gios_wmode(W_REPLACE);
}
