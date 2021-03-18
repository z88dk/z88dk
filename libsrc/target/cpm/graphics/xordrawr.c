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


void xordrawr(int x,int y)
{
	gios_wmode(W_COMPLEMENT);
	gios_drawr(48*x,-(y*128));
	gios_wmode(W_REPLACE);
}
