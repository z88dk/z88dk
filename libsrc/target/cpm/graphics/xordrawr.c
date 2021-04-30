/*
 *	CP/M GSX based graphics libraries
 *
 *	xordrawr(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: xordrawr.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ xordrawr(int px, int py) __smallc;

extern int  __LIB__ gsx_xoffs(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yoffs(int y) __z88dk_fastcall;


void xordrawr(int x,int y)
{
	gios_wmode(W_COMPLEMENT);
	gios_drawr(gsx_xoffs(x),gsx_yoffs(y));
	gios_wmode(W_REPLACE);
}
