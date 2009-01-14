/*=========================================================================

GFX EXAMPLE CODE - #2
	"random faces"

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
	u_char g[8];
	u_int addr;
	int c;
	u_char buf[256];

	set_color(15, 1, 1);

	// set video mode to screen 2
	set_mode(mode_2);

	// define smiley face :)
	g[0] = 60;
	g[1] = 66;
	g[2] = 165;
	g[3] = 129;
	g[4] = 165;
	g[5] = 153;
	g[6] = 66;
	g[7] = 60;

	// draw the smiley shape over the entire buffer
	for (c=0; c<256; c++)
		buf[c] = g[c & 7];
	
	// set whole screen to color black
	fill(0x2000, 0x11, MODE2_MAX);

	// blit the buffer for each "line", as a smiley pattern for the whole screen
	for (c = 0; c < 24; c++)
		vwrite(buf, c * 256, 256);

	while (!get_trigger(0)) {
		// randomly color one chosen smiley
		c = rand() & 15;
		addr = (rand() % MODE2_MAX) & ~(7);
		fill(MODE2_ATTR + addr, c << 4, 8);
	}	

	set_mode(mode_0);
}
