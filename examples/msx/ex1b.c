/*=========================================================================

GFX EXAMPLE CODE - #1
	"pixel stars"

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
#include <msx/gfx.h>


typedef struct {
	int x;
	int y;
	int z;
	unsigned int addr, last;
	unsigned char sub;
} star_t;

void star_randomize(star_t* st) {
	st->x = ((rand() & 255) - 128);
	st->y = ((rand() & 255) - 128);
	st->z = 64;
}

void star_move(star_t* st) {
	int x, y, z;
	z = (st->z -= 1);
	x = (st->x / z) + 128;
	y = (st->y / z) + 96;
	if (z < 1|| x < 0 || x >= MODE2_WIDTH || y < 0 || y >= MODE2_HEIGHT) {
		star_randomize(st);
		z = st->z;
		x = (st->x / z) + 128;
		y = (st->y / z) + 96;
	}
	st->last = st->addr;
	st->addr = map_pixel(x, y);
	st->sub  = map_subpixel(x);
}

#define MAX_STARS 16

main() {
	unsigned char c;
	star_t *st, stars[MAX_STARS];

	set_color(15, 1, 1);

	// set video mode to screen 2
	set_mode(mode_2);
	//msx_screen(2);

	// set whole screen to color white/black
	fill(MODE2_ATTR, 0xf1, MODE2_MAX);

	// initialize stars
	for (c=0; c < MAX_STARS; c++) {
		st = stars + c;
		star_randomize(st);
		st->z = (rand() & 63) ;
		st->addr = 0;
	}

	// animation loop
	while (!get_trigger(0)) {
		// calculate star movement
		for (st=stars, c=0; c < MAX_STARS; c++, st++)
			star_move(st);

		// erase previous stars
		for (st=stars, c=0; c < MAX_STARS; c++, st++)
			vpoke(st->last, 0);

		// show new stars
		for (st=stars, c=0; c < MAX_STARS; c++, st++)
			vmerge(st->addr, st->sub);
	}

	//set_mode(mode_0);
	msx_screen(0);
}
