/*=========================================================================

GFX EXAMPLE CODE - #4
	"moving sprites"

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
#include <math.h>
#include "msx/gfx.h"

typedef struct {
	int x;
	int y;
} point_t;

#define MAX_POINT	256

main() {
	double	m_pi;
	double	a;
	int	c, i, l;
	point_t	p[MAX_POINT];

	printf("calculating, wait...");

	m_pi = 8.0 * atan(1.0);

	// precalculate trajetory
	for (c = 0; c < MAX_POINT; c++) {
		a = (m_pi * (double)c) / (double)MAX_POINT;
		p[c].x = ((int)(100.0 * cos(a))) + (128 - 8);
		p[c].y = ((int)(80.0 * sin(a))) + (96 - 8);

		if (c & 8)
			putch('.');
	}
	printf("done!\n");
	
	// set graphic screen
	set_color(15, 1, 1);
	set_mode(mode_2);
	set_sprite_mode(sprite_large);

	fill(MODE2_ATTR, 0xF1, MODE2_MAX);

	// create one sprite with a shape from the character table
	//set_sprite_16(0, (void*)(0x1BBF + 8));
	msx_vwrite((void*)(0x1BBF + 8), 14336, 32);

	while (!get_trigger(0)) 
		for (c = 0; c < MAX_POINT; c++) { // for each starting point
			for (i = 0; i < 8; i++) { // set location for the 8 sprites contiguously
				l = (c + (i << 4)) % MAX_POINT;
				put_sprite_16(i, p[l].x, p[l].y, 0, i + 2);
			}
		}

	set_mode(mode_0);
}
