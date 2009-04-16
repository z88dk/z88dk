/*=========================================================================

GFX EXAMPLE CODE - #9
	"sprite stars"

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

// note: this is exactly the same as ex #1, but with sprites instead of 
// pixels

#include <stdlib.h>
#include "msx/gfx.h"

// 8x8 sprite with only the top-left pixel lit
char star[] = {128,0,0,0,0,0,0,0};

typedef struct {
	int x;
	int y;
	int z;
	int sx, sy;
} star_t;

void star_randomize(star_t* st) {
	st->x = i2f((rand() & 63) - 32);
	st->y = i2f((rand() & 63) - 32);
	st->z = 64;
}

void star_move(star_t* st) {
	int x, y, z;
	z = (st->z -= 2);
	x = f2i(divfx(st->x, z)) + 128;
	y = f2i(divfx(st->y, z)) + 96;
	if (z < 1 || x < 0 || x >= MODE2_WIDTH || y < 0 || y >= MODE2_HEIGHT) {
		star_randomize(st);
		z = st->z;
		x = f2i(divfx(st->x, z)) + 128;
		y = f2i(divfx(st->y, z)) + 96;
	}
	st->sx = x;
	st->sy = y;
}

#define MAX_STARS 16

main() {
	u_char c;
	star_t *st, stars[MAX_STARS];

	set_color(15, 1, 1);

	// set video mode to screen 2
	set_mode(mode_2);

	// set whole screen to color white/black
	fill(MODE2_ATTR, 0xf1, MODE2_MAX);

	// initialize stars
	for (c=0; c < MAX_STARS; c++) {
		st = stars + c;
		star_randomize(st);
		st->z = (rand() & 63) << 2;
	}

	// define sprite

	set_sprite_mode(sprite_default);
	set_sprite_8(0, star);

	// animation loop
	while (!get_trigger(0)) {
		// calculate star movement
		for (st=stars, c=0; c < MAX_STARS; c++, st++)
			star_move(st);

		// show stars
		for (st=stars, c=0; c < MAX_STARS; c++, st++)
			put_sprite_8(c, st->sx, st->sy, 0, 15);
	}

	set_mode(mode_0);
}
