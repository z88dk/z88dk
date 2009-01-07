/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Advanced Line Drawing
	
	$Id: msx_compute_line.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_compute_line(int x1, int y1, int x2, int y2, line_t *r) {
	int deltax, deltay;

	deltax = (x2 - x1); if (deltax<0) deltax=-deltax;
	deltay = (y2 - y1); if (deltay<0) deltay=-deltay;

	if (deltax >= deltay) {
		r->numpixels = deltax + 1;
		r->d = (2 * deltay) - deltax;
		r->dinc1 = deltay << 1;
		r->dinc2 = (deltay - deltax) << 1;
		
		r->xinc1 = 1;
		r->xinc2 = 1;
		
		r->yinc1 = 0;
		r->yinc2 = 1;
	} else {
		r->numpixels = deltay + 1;
		r->d = (2 * deltax) - deltay;
		r->dinc1 = deltax << 1;
		r->dinc2 = (deltax - deltay) << 1;
		
		r->xinc1 = 0;
		r->xinc2 = 1;
		
		r->yinc1 = 1;
		r->yinc2 = 1;
	}

	if (x1 > x2) {
		r->xinc1 = -(r->xinc1);
		r->xinc2 = -(r->xinc2);
	}
	if (y1 > y2) {
		r->yinc1 = -(r->yinc1);
		r->yinc2 = -(r->yinc2);
	}
}

