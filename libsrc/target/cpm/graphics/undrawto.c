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

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void undrawto(int x,int y)
{
	gios_wmode(W_ERASE);
	gios_drawto(gsx_xscale(x),gsx_yscale(y));
	gios_wmode(W_REPLACE);
}
