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
#include <stdlib.h>
#include <msx/gfx.h>


	unsigned char stencil[MODE2_HEIGHT*2];
	//u_char *buf;

	unsigned char buf[MODE2_MAX];

main() {
	int c, l;
	unsigned char i;
	surface_t surf;

	//buf = (u_char*)malloc(MODE2_MAX);
	
	surf.data.ram = buf;

	set_color(15, 1, 1);
	set_mode(mode_2);
	fill(MODE2_ATTR, 0x31, MODE2_MAX);

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

		msx_vwrite_direct(surf.data.ram, 0, MODE2_MAX);
		if (get_trigger(0))
			break;
	}

	set_mode(mode_0);
}
