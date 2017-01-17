
/* 
 * To build the 'draw_profile' demo:
 * 
 * z80svg -a -otest rabbit.svg
 * (or, non automatic mode..  z80svg -otest -x40 -y20 -s70 rabbit.svg)
 * zcc +zx -lndos -create-app -o rabbit test.c
 * 
 * $Id: test.c,v 1.2 2012-11-24 10:54:30 stefano Exp $
 */

#include <graphics.h>
#include <gfxprofile.h>
#include <test.h>



int main ()
{
	clg();
	//            X  Y  scale %
	draw_profile(170, 0, 80, svg_picture);
	draw_profile(90, 0, 120, svg_picture);
	draw_profile(3, 3, 200, svg_picture);
}

