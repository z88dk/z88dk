/*
 *	CP/M GSX based graphics libraries
 *
 *	setxy(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: setxy.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ setxy(int x, int y) __smallc;

extern int  __LIB__ gsx_xscale(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yscale(int y) __z88dk_fastcall;


void setxy(int x, int y)
{
	gios_ptsin[2]=gsx_xscale(x);
	gios_ptsin[3]=gsx_yscale(y);
}
