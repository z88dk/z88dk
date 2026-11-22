/*=========================================================================

GFX EXAMPLE CODE - #10
	"shaded triangle"

Copyright (C) 2004  Rafael de Oliveira Jannone

This example's source code is Public Domain.

WARNING: The author makes no guarantees and holds no responsibility for 
any damage, injury or loss that may result from the use of this source 
code. USE IT AT YOUR OWN RISK.

Contact the author:
	by e-mail : rafael AT jannone DOT org
	homepage  : http://jannone.org/gfxlib
	ICQ UIN   : 10115284

=========================================================================*/

#include <msx/defs.h>
#include <stdio.h>
#include <string.h>
#include <video/tms99x8.h>


unsigned char stencil[MODE2_HEIGHT*2];
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
		stencil_init(stencil);

		// calculate polygon
		//calculate_side
		stencil_add_side(128 + c, c + 20, 40, 180 - c, stencil);
		stencil_add_side(128 + c, c + 20, 255 - c, 96, stencil);
		stencil_add_side(255 - c, 96, 40, 180 - c, stencil);
		c = (c + 4) & 63;
		i = (c + 15) /6-2;

		surface_stencil_render(&surf, stencil, i);

		vdp_vwrite_direct(surf.data.ram, 0, MODE2_MAX);
		if (getk())
			break;
	}

	vdp_set_mode(mode_0);
}
