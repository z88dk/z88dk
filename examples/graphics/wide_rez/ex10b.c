/*=========================================================================

GFX EXAMPLE CODE - #10b
	"shaded 3D blocks"
	
	Wide resolution version, without surface buffer (still not implemented)

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
#include <spectrum.h>

#pragma output nogfxglobals
unsigned char stencil[256*4];

main() {
	int c, l;
	unsigned char i;
	unsigned int dly;

	clg();

	c = 0;

	// paint polygon
for (;;) {
		
		clg();

		for (i=4;i>0;i--) {
			// fake light source
			stencil_init(stencil);
			stencil_add_circle(getmaxx()/2-50+c*3-i, 42+i, i*3+10, 1, stencil);
			stencil_render(stencil, i);
		}

		for (i=10;i>0;i--) {
			stencil_init(stencil);
			stencil_add_circle(getmaxx()/2+(33-(i*3)), 145 - i, i*6 ,1, stencil);
			stencil_add_side(getmaxx()/2-i*6+(33-(i*3)), 145 - i, getmaxx()/2, 30+i, stencil);
			stencil_add_side(getmaxx()/2+i*6+(33-(i*3)), 145 - i, getmaxx()/2, 30+i, stencil);
			stencil_render(stencil, (12-i)*(c+1)/6);
		}

		for (dly=0;dly<30000;dly++) {};

		c = (c+1) & 15;
	}
}
