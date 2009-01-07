/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Draw a line on video (slow)
	
	$Id: msx_line_slow.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>



void msx_line_slow(int x1, int y1, int x2, int y2)
{
	REVERSE_LINE_T_MEMBERS;

	int i, x, y;
	unsigned int addr, last;
	unsigned char value;

	msx_compute_line(x1, y1, x2, y2, (line_t *)&LINE_T_FIRST);

	x = x1;
	y = y1;
	addr = map_pixel(x, y);
	last = addr;
	value = msx_vpeek(addr);

	for (i=0; i < numpixels; i++) {
		value |= map_subpixel(x);
		if (d<0) {
			d += dinc1;
			x += xinc1;
			y += yinc1;
		}
		else
		{
			d += dinc2;
			x += xinc2;
			y += yinc2;
		}
		addr = map_pixel(x, y);
		if (last != addr) {
			msx_vpoke(last, value);
			value = msx_vpeek(addr);
			last = addr;
		}
	}
	msx_vpoke(addr, value);
}

