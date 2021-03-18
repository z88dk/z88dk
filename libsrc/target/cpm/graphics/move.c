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

void move(int x,int y)
{
	if (_pen[0] & 128)
		gios_drawr(48*x,-(y*128));
	else {
		gios_ptsin[2]=gios_ptsin[2]+48*x;
		gios_ptsin[3]=gios_ptsin[3]-(y*128);
	}
}
