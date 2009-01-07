/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Draw horizontal line on video. \a value can be a bit pattern. note: x1 <= x2
	
	$Id: msx_hline.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_hline(int x1, int y1, int x2, unsigned char value) {
	int bi, bf;
	unsigned char di, df, c;
	int data;

	if (x1 > x2)
		return;

	data = map_pixel(x1, y1);

	bi = x1 >> 3;
	bf = x2 >> 3;
	di = x1 & 7;
	if (bi == bf) {
		c = ~(unsigned char)(255 >> (unsigned char)(x2 - x1 + 1)) >> di;
		msx_vpoke(data, (c & value) | (msx_vpeek(data) & ~c));
		return;
	}
	df = x2 & 7;
	if (di > 0) {
		c = 255 >> di;
		msx_vpoke(data, (c & value) | (msx_vpeek(data) & ~c));
		data += 8;
		++bi;
	}
	if (df < 7) {
		--bf;
	}
	while (bi <= bf) {
		msx_vpoke(data, value);
		data += 8;
		bi++;
	}
	if (df < 7) {
		c = ~(255 >> df);
		msx_vpoke(data, (c & value) | (msx_vpeek(data) & ~c));
	}
}

