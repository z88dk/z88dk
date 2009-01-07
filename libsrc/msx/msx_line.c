/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Draw a line on video
	
	$Id: msx_line.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_line(int x1, int y1, int x2, int y2)
{
	REVERSE_LINE_T_MEMBERS;

	int i;
	unsigned int addr, last;
	unsigned char bit, value;

	msx_compute_line(x1, y1, x2, y2, (line_t *)&LINE_T_FIRST);

	addr = map_pixel(x1, y1);
	bit = map_subpixel(x1);
	value = msx_vpeek(addr);
	last = addr;

	for (i=0; i < numpixels; i++) {
		value |= bit;

		if (d<0) {
			d += dinc1;
			if (xinc1) {
				if (xinc1 > 0) {
					bit >>= 1;
					if (!bit) {
						addr += 8;
						bit = 128;
					}
				} else {
					bit <<= 1;
					if (!bit) {
						addr -=8;
						bit = 1;
					}
				}
			}
			if (yinc1) {
				if (yinc1 > 0) {
					addr += 1;
					if (!(addr & 7))
						addr += 256 - 8;
				} else {
					addr -= 1;
					if ((addr & 7) == 7)
						addr -= 256 - 8;
				}
			}
		}
		else
		{
			d += dinc2;
			if (xinc2) {
				if (xinc2 > 0) {
					bit >>= 1;
					if (!bit) {
						addr += 8;
						bit = 128;
					}
				} else {
					bit <<= 1;
					if (!bit) {
						addr -=8;
						bit = 1;
					}
				}
			}
			if (yinc2) {
				if (yinc2 > 0) {
					addr += 1;
					if (!(addr & 7))
						addr += 256 - 8;
				} else {
					addr -= 1;
					if ((addr & 7) == 7)
						addr -= 256 - 8;
				}
			}
		}
		if (last != addr) {
			msx_vpoke(last, value);
			value = msx_vpeek(addr);
			last = addr;
		}
	}
	msx_vpoke(addr, value);
}

