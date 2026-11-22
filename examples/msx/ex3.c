/*=========================================================================

GFX EXAMPLE CODE - #3
	"colorful bars"

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

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <video/tms99x8.h>

void main() {
	uint16_t addr;
	int c, l;

	vdp_color(15, 1, 1);

	// set video mode to screen 2
	vdp_set_mode(mode_2);

	// draw horizontal lines
	for (c = 0; c < MODE2_MAX; c += 8)
		vdp_vpoke(MODE2_ATTR + c, 0xFF);

	// for each column...
	for (c = 0; c < 32; c++) {
		// randomly draw one colored vertical bar
		l = rand() & 63;
		addr = map_pixel(c << 3, 96 - l);
		vdp_vfill(8192 + addr, (c % 14) + 2, l << 1);
	}	
	while (!getk()) {}

	vdp_set_mode(mode_0);
}
