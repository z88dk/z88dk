/*
 *	CP/M GSX based graphics libraries
 *
 *	drawr(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: drawr.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ drawr(int px, int py) __smallc;

extern int  __LIB__ gsx_xoffs(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yoffs(int y) __z88dk_fastcall;


void drawr(int x,int y)
{
	gios_drawr(gsx_xoffs(x),gsx_yoffs(y));
}
