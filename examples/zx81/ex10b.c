/*=========================================================================

GFX EXAMPLE CODE - #10b
	"shaded 3D blocks"
	
	ZX81 version, without surface buffer (still not implemented)
	this one can be easily ported on all the high resolution target platforms

Copyright (C) 2004  Rafael de Oliveira Jannone
Copyright (C) 2009  Stefano Bodrato

This example's source code is Public Domain.

WARNING: The author makes no guarantees and holds no responsibility for 
any damage, injury or loss that may result from the use of this source 
code. USE IT AT YOUR OWN RISK.

Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284

=========================================================================*/

#include <graphics.h>
#include <zx81.h>

	unsigned char stencil[192*2];

main() {
	int c, l;
	unsigned char i;
	unsigned int dly;

	clg();
	invhrg();
//	zx_border(0);
//	zx_colour(PAPER_BLACK|INK_WHITE);

	c = 0;

	// paint polygon
	for (;;) {
		
		clg();
		for (i=4;i>0;i--) {
			// fake light source
			stencil_init(stencil);
			stencil_add_circle(80+c*3-i, 42+i, i*3+5, 1, stencil);
			stencil_render(stencil, 14-(i*2));
		}

		for (i=11;i>0;i--) {
			stencil_init(stencil);
			stencil_add_circle(128+(11-i), 150 - i, i*3 ,1, stencil);
			stencil_add_side(128-i*3+(11-i), 150 - i, 128, 30+i, stencil);
			stencil_add_side(128+i*3+(11-i), 150 - i, 128, 30+i, stencil);
			stencil_render(stencil, 6*(12-i)/(c+1));
		}

		for (dly=0;dly<30000;dly++) {};

		c = (c+1) & 15;
	}
}
