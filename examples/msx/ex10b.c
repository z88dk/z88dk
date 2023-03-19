/*=========================================================================

GFX EXAMPLE CODE - #10b
	"shaded 3D blocks"

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

#include <stdio.h>
#include <string.h>

#include <video/tms99x8.h>


unsigned char stencil[MODE2_HEIGHT*2];
//unsigned char high[MODE2_HEIGHT];
//u_char *buf;

unsigned char buf[MODE2_MAX];

void main() {
	int c, l;
	unsigned char i;
	surface_t surf;

	//buf = (u_char*)malloc(MODE2_MAX);
	
	surf.data.ram = buf;

	vdp_color(15, 1, 1);
	vdp_set_mode(mode_2);
	vdp_vfill(MODE2_ATTR, 0x31, MODE2_MAX);

	c = 0;
	//i = 0;

	// paint polygon
	for (;;) {	
		memset(buf, 0, MODE2_MAX);	// yeah... crap
		
		for (i=4;i>0;i--) {
			// fake light source
			stencil_init(stencil);
			stencil_add_circle(80+c*3-i, 42+i, i*3+5, 1, stencil);
			surface_stencil_render(&surf, stencil, 14-(i*2));
		}

		for (i=11;i>0;i--) {
			stencil_init(stencil);
			stencil_add_circle(128+(11-i), 150 - i, i*3 ,1, stencil);
			stencil_add_side(128-i*3+(11-i), 150 - i, 128, 30+i, stencil);
			stencil_add_side(128+i*3+(11-i), 150 - i, 128, 30+i, stencil);
			surface_stencil_render(&surf, stencil, 6*(12-i)/(c+1));
		}

		c = (c+1) & 15;

		vdp_vwrite_direct(surf.data.ram, 0, MODE2_MAX);
		if (getk())
			break;
	}

	vdp_set_mode(mode_0);
}
