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
#include <graphics.h>


void drawr(int x,int y)
{
	gios_drawr(48*x,128*(255-y));
}
