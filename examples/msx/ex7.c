/*=========================================================================

GFX EXAMPLE CODE - #7
	"starship game, a recap of all things"

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

// note: this is my personal favorite demo :) - Rafael

#include <stdio.h>
#include <stdint.h>
#include <games.h>
#include <video/tms99x8.h>

// shapes and attributes

/*
extern uint8_t grass1[8];
extern uint8_t grass1_attr[8];
extern uint8_t grass2[8];
extern uint8_t grass2_attr[8];
extern uint8_t water1[8];
extern uint8_t water2[8];
extern uint8_t water3[8];

extern uint8_t spaceship[32];
extern uint8_t fire[32];
*/


// binary data (shapes, attributes, whatever...)
/*
#asm

._grass1
	defb	@00000000
	defb	@00111000
	defb	@00000000
	defb	@10000011
	defb	@00000000
	defb	@00110000
	defb	@00000100
	defb	@00011010

._grass1_attr
	defb	032h ;00000000
	defb	032h ;00111000
	defb	032h ;00000000
	defb	0B2h ;10000011
	defb	032h ;00000000
	defb	032h ;00110000
	defb	0B2h ;00000100
	defb	0A2h ;00011010
*/

uint8_t grass1[] = {0, 0x38, 0, 0x83 , 0, 0x30, 4, 0x1a};
uint8_t grass1_attr[] = {0x32, 0x32, 0x32, 0xB2, 0x32, 0x32, 0xB2, 0xA2};

/*
._grass2
	defb	@01011000
	defb	@00000000
	defb	@00000000
	defb	@11100000
	defb	@00000000
	defb	@00000111
	defb	@00000000
	defb	@00100000

._grass2_attr
	defb	0A2h 
	defb	032h 
	defb	032h 
	defb	0B2h 
	defb	032h 
	defb	032h 
	defb	032h 
	defb	0B2h 
*/
uint8_t grass2[] = {0x58, 0, 0, 0xE0, 0, 7, 0, 0x20};
uint8_t grass2_attr[] = {0xA2, 0x32, 0x32, 0xB2, 0x32, 0x32, 0x32, 0xB2};

/*
._water1
	defb	@00000000
	defb	@11111000
	defb	@00000000
	defb	@00000000
	defb	@00111111
	defb	@00000000
	defb	@00000000
	defb	@00000000

._water2
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@11111111
	defb	@00000000
	defb	@00000111
	defb	@00000000

._water3
	defb	0,0,0,0,0,0,0,0
*/

uint8_t water1[] = {0, 0, 0, 0, 0xFF, 0, 7, 0};
uint8_t water2[] = {0, 0xF8, 0, 0, 0x3F, 0, 0, 0};
uint8_t water3[] = {0, 0, 0, 0, 0, 0, 0, 0};

/*
._spaceship
	defb	@00000011
	defb	@00000011
	defb	@00000011
	defb	@00000111
	defb	@00000111
	defb	@11000111
	defb	@11000111
	defb	@11100111
	defb	@11101110
	defb	@11101110
	defb	@11111110
	defb	@11111111
	defb	@11100111
	defb	@11000011
	defb	@11110000
	defb	@10010000
	
	defb	@11000000
	defb	@11000000
	defb	@11000000
	defb	@11100000
	defb	@11100000
	defb	@11100011
	defb	@11100011
	defb	@11100111
	defb	@01110111
	defb	@01110111
	defb	@01111111
	defb	@11111111
	defb	@11100111
	defb	@11000011
	defb	@00001111
	defb	@00001001
*/

uint8_t spaceship[] = {3, 3, 3, 7, 7, 0xc7, 0xc7, 0xe7, 0xee, 0xee, 0xfe, 0xff, 0xe7, 0xc3, 0xf0, 0x90,
					0xc0, 0xc0, 0xc0, 0xe0, 0xe0, 0xe3, 0xe3, 0xe7, 0x77, 0x77, 0x7f, 0xff, 0xe7, 0xc3, 0x0f, 9 };

/*
._fire
	defb	@00011000
	defb	@00111100
	defb	@00111100
	defb	@01111110
	defb	@01111110
	defb	@01111110
	defb	@01110110
	defb	@01010100
	defb	@00010000
	defb	@00010000
	defb	@00010000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	@00000000
	defb	0,0,0,0,0,0,0,0
	defb	0,0,0,0,0,0,0,0

#endasm
*/

uint8_t fire[] = {0x18, 0x3C, 0x3C, 0x7E, 0x7E, 0x7E, 0x76, 0x54, 0x10, 0x10, 0x10, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

// terrain definitions

#define MAP_WIDTH	32
#define MAP_HEIGHT	24
#define MAP_SIZE	MAP_WIDTH * MAP_HEIGHT


// helper

#define KEEP_RANGE(var, min, max) \
	if (var < min) var = min; else if (var > max) var = max


// terrain functions

void show_map(uint8_t *map, int line_start) {
	int y, addr;
	uint8_t *l;

	l = map + (line_start * MAP_WIDTH);
	addr = 6144;
	for (y = line_start; y < MAP_HEIGHT; y++) {
		vdp_vwrite(l, addr, MAP_WIDTH);
		addr += MAP_WIDTH;
		l += MAP_WIDTH;
	}
	l = map;
	for (y = 0; y < line_start; y++) {
		vdp_vwrite(l, addr, MAP_WIDTH);
		addr += MAP_WIDTH;
		l += MAP_WIDTH;
	}
}

void map_fill_line(uint8_t* myline, int river_width, int river_offs) {
	int river_left;
	uint8_t *last;

	river_left = (MAP_WIDTH - river_width) / 2 + river_offs;
	last = myline + MAP_WIDTH;

	while (river_left--)
		*myline++ = (rand() & 1) + '%';

	while (river_width--)
		*myline++ = (rand() % 3) + '"';

	while (myline < last)
		*myline++ = (rand() & 1) + '%';
}

void randomize_river(int *width, int *offs) {
	*width += (rand() & 2) - 1;
	*offs  += (rand() & 2) - 1;
	KEEP_RANGE(*width, 8, 16);
	KEEP_RANGE(*offs, -4, 4);
}


// player data

typedef struct {
	int x;
	int y;	
	int vx, vy;
	uint8_t trig;
} player_t;


// rocket data

typedef struct {
	int x;
	int y;
	uint8_t sp;
	uint8_t active;
} rocket_t;


// maximum number of rockets at a time

#define MAX_ROCKET	3


// rocket functions

rocket_t* alloc_rocket(rocket_t *array) {
	int c;
	for (c = 0; c < MAX_ROCKET; c++) {
		if (!array->active) {
			array->active = 1;
			array->sp = 10 + c;
			return array;
		}
		++array;
	}
	return NULL;
}

void free_rocket(rocket_t *r) {
	r->active = 0;
	vdp_put_sprite_16(r->sp, 0, 192, 0, 0);
}

void initialize_rockets(rocket_t *array) {
	int c;
	for (c = 0; c < MAX_ROCKET; c++)
		free_rocket(array++);
}

void move_rockets(rocket_t *array) {
	int c;
	for (c = 0; c < MAX_ROCKET; c++) {
		if (array->active) {
			if ((array->y -= 7) < 0)
				free_rocket(array);
			else
				vdp_put_sprite_16(array->sp, array->x, array->y, 1, 6);
		} 
		++array;
	}
}


// player functions

void move_player(player_t *player) {
	uint8_t s;
	char ax, ay;
	
	s = joystick(1);

	ay = (s & MOVE_UP) ? -1 : ((s & MOVE_DOWN) ? 1 : 0);
	ax = (s & MOVE_LEFT) ? -1 : ((s & MOVE_RIGHT) ? 1 : 0);
	
	player->vx += ax;
	player->vy += ay;
	KEEP_RANGE(player->vx, -3, 3);
	KEEP_RANGE(player->vy, -3, 3);

	player->x += player->vx;
	player->y += player->vy;

	vdp_put_sprite_16(0, player->x, player->y, 0, 15);
	vdp_put_sprite_16(31, player->x + 6, player->y + 6, 0, 1);		
}


// main :)

void main() {
	// allocating stuff

	int c, river_width, river_offs;
	player_t player;
	rocket_t rockets[MAX_ROCKET], *rckt;

	uint8_t *l;
	uint8_t map[MAP_WIDTH * MAP_HEIGHT];

	// set screen
	vdp_color(15, 1, 1);
	vdp_set_mangled_mode();

	// set sprites
	vdp_set_sprite_mode(sprite_large);

	vdp_set_sprite_16(0, spaceship);
	vdp_set_sprite_16(1, fire);

	// set char shapes and colors
	vdp_set_char('"', water1, NULL, 0x54, place_all);
	vdp_set_char('#', water2, NULL, 0x54, place_all);
	vdp_set_char('$', water3, NULL, 0x54, place_all);
	vdp_set_char('%', grass1, grass1_attr, 0, place_all);
	vdp_set_char('&', grass2, grass2_attr, 0, place_all);

	// initializing 
	initialize_rockets(rockets);

	river_width = 16;
	river_offs = 0;

	l = map + MAP_SIZE - MAP_WIDTH;
	for (c = 0; c < MAP_HEIGHT; c++) {
		randomize_river(&river_width, &river_offs);
		map_fill_line(l, river_width, river_offs);
		l -= MAP_WIDTH;
	}

	c = 0;

	player.x = 128;
	player.y = 96;
	player.vx = player.vy = player.trig = 0;

	// main loop
	for (;;) {
		move_player(&player);

		player.trig |= joystick(1) & MOVE_FIRE;

		if ((c & 2) && player.trig && (rckt = alloc_rocket(rockets))) {
			rckt->x = player.x + 4;
			rckt->y = player.y - 8;
			player.trig = 0;
		}
		move_rockets(rockets);

		if (--c < 0)
			c += MAP_HEIGHT;
		l = map + c * MAP_WIDTH;
		randomize_river(&river_width, &river_offs);
		map_fill_line(l, river_width, river_offs);
		show_map(map, c);
	}
}


