/*
 *	CP/M GSX based graphics libraries
 *
 *	plot(x,y)
 *
 *	Stefano Bodrato - 2021
 *
 *	$Id: plot.c $
 */

#include <cpm.h>
//#include <graphics.h>
extern void __LIB__ plot(int x, int y) __smallc;

void plot(int x, int y)
{
	gios_plot(48*x,128*(255-y));
}
