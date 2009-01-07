/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Draw horizontal line on surface. \a value can be a bit pattern. note: x1 <= x2
	
	$Id: msx_surface_hline.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_surface_hline(surface_t* s, int x1, int y1, int x2, unsigned char value) {
	int bi, bf;
	unsigned char di, df, c;
	unsigned char *data;

	if (x1 > x2)
		return;

	data = s->data.ram + map_pixel(x1, y1);

	bi = x1 >> 3;
	bf = x2 >> 3;
	di = x1 & 7;
	if (bi == bf) {
		c = ~(unsigned char)(255 >> (unsigned char)(x2 - x1 + 1)) >> di;
		*data = (c & value) | (*data & ~c);
		return;
	}
	df = x2 & 7;
	if (di > 0) {
		c = 255 >> di;
		*data = (c & value) | (*data & ~c);
		data += 8;
		++bi;
	}
	if (df < 7) {
		--bf;
	}
	while (bi <= bf) {
		*data = value;
		data += 8;
		bi++;
	}
	if (df < 7) {
		c = ~(255 >> df);
		*data = (c & value) | (*data & ~c);
	}
}

