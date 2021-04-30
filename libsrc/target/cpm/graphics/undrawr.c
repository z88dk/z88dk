/*
 *	CP/M GSX based graphics libraries
 *
 *	undrawr(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: undrawr.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ undrawr(int px, int py) __smallc;

extern int  __LIB__ gsx_xoffs(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yoffs(int y) __z88dk_fastcall;


void undrawr(int x,int y)
{
	gios_wmode(W_ERASE);
	gios_drawr(gsx_xoffs(x),gsx_yoffs(y));
	gios_wmode(W_REPLACE);
}
