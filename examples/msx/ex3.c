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

#include <stdlib.h>
#include "msx/gfx.h"

main() {
	u_int addr;
	int c, l;

	set_color(15, 1, 1);

	// set video mode to screen 2
	set_mode(mode_2);

	// draw horizontal lines
	for (c = 0; c < MODE2_MAX; c += 8)
		vpoke(MODE2_ATTR + c, 0xFF);

	// for each column...
	for (c = 0; c < 32; c++) {
		// randomly draw one colored vertical bar
		l = rand() & 63;
		addr = map_pixel(c << 3, 96 - l);
		fill_v(8192 + addr, (c % 14) + 2, l << 1);
	}	
	while (!get_trigger(0)) {}

	set_mode(mode_0);
}
