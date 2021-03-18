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


void undrawr(int x,int y)
{
	gios_wmode(W_ERASE);
	gios_drawr(48*x,-(y*128));
	gios_wmode(W_REPLACE);
}
