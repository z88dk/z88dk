/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Calculate a triangle side
	
	$Id: msx_calculate_side.c,v 1.3 2009-04-15 21:00:58 stefano Exp $
*/

#include <msx.h>
#include <msx/defs.h>


#define MAX(a, b) (((a) > (b)) ? (a) : (b))
#define MIN(a, b) (((a) < (b)) ? (a) : (b))

void msx_calculate_side(int x1, int y1, int x2, int y2, int low[], int high[]) {
	int step;
	int lines;
	int ly, hy, ux;
	int *pl, *ph;

	if (y2 < y1) {
		int t;
		t = x2; x2 = x1; x1 = t;
		t = y2; y2 = y1; y1 = t;		
	}
	lines = y2 - y1;

	pl = low + y1;
	ph = high + y1;

	if (!lines) {
		ly = *pl; hy = *ph;
		if (x1 < x2) {
			low[y1] = MIN(ly, x1); high[y1] = MAX(hy, x2);
		} else {
			low[y1] = MIN(ly, x2); high[y1] = MAX(hy, x1);
		}
		return;
	}

	step = i2f(x2 - x1);
	step /= lines;
	x1 = i2f(x1);

	while (lines--) {
		ly = *pl; hy = *ph;
		ux = f2i(x1);
		*pl++ = MIN(ly, ux); *ph++ = MAX(hy, ux);
		x1 += step;
	}
}

