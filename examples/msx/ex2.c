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

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <video/tms99x8.h>

void main() {
	uint8_t g[8];
	uint16_t addr;
	int c;
	uint8_t buf[256];

	vdp_color(15, 1, 1);

	// set video mode to screen 2
	vdp_set_mode(mode_2);

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
	vdp_vfill(0x2000, 0x11, MODE2_MAX);

	// blit the buffer for each "line", as a smiley pattern for the whole screen
	for (c = 0; c < 24; c++)
		vdp_vwrite(buf, c * 256, 256);

	while (!getk()) {
		// randomly color one chosen smiley
		c = rand() & 15;
		addr = (rand() % MODE2_MAX) & ~(7);
		vdp_vfill(MODE2_ATTR + addr, c << 4, 8);
	}	

	vdp_set_mode(mode_0);
}
