/*
 *	CP/M GSX based graphics libraries
 *
 *	move(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: move.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ move(int px, int py) __smallc;
extern unsigned char _pen[];

extern int  __LIB__ gsx_xoffs(int x) __z88dk_fastcall;
extern int  __LIB__ gsx_yoffs(int y) __z88dk_fastcall;


void move(int x,int y)
{
	if (_pen[0] & 128)
		gios_drawr(gsx_xoffs(x),gsx_yoffs(y));
	else {
		gios_ptsin[2]=gios_ptsin[2]+gsx_xoffs(x);
		gios_ptsin[3]=gios_ptsin[3]+gsx_yoffs(y);
	}
}
