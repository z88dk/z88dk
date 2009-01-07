/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Draw a line on a surface
	
	$Id: msx_surface_line.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_surface_line(surface_t *s, int x1, int y1, int x2, int y2) {
	REVERSE_LINE_T_MEMBERS;

	int i;
	unsigned int addr;
	unsigned char* data, bit;

	msx_compute_line(x1, y1, x2, y2, (line_t *)&LINE_T_FIRST);

	data = s->data.ram;
	addr = map_pixel(x1, y1);
	bit = map_subpixel(x1);

	i = numpixels;
	while (i--) {
		data[addr] |= bit;

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
	}
}

