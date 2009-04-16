/*=========================================================================

GFX EXAMPLE CODE - #8
	"alphabets"

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
#include "msx/gfx.h"

#define VRAM_OFFS	0
#define FILE_OFFS	7
#define MAX_BUF		(256 * 8)

// cursor shape
extern void *square;

// binary data for cursor shape
#asm
._square
	defb @11100111
	defb @10000001
	defb @10000001
	defb @00000000
	defb @00000000
	defb @10000001
	defb @10000001
	defb @11100111

#endasm


// zooms into a char shape
void preview_char(u_char* p) {
	int x, y, addr;
	u_char c;

	for (y = 0; y < 8; y++) {
		addr = map_pixel(22 * 8, (y << 3) + 8);
		c = *p++;
		for (x = 0; x < 8; x++) {
			fill(addr, (c & 128) ? 255 : 0, 8);
			c <<= 1;
			addr += 8;
		}
	}
}

// do the whole preview table and stuff :)
void do_preview(u_char* buf) {
	int asc, x, y, addr;
	u_char st;

	set_color(15, 4, 4);
	set_sprite_8(0, square);

	fill(MODE2_ATTR, 0xF0, MODE2_MAX);

	// start blitting buffer at pixel (16,16)
	addr = map_block(16, 16);

	// 16 chars of width (*8), 16 "lines", jump 256 in VRAM for each line
	blit_ram_vram(buf, addr, 16 * 8, 16, 16 * 8, 256);

	// fill yellow background
	blit_fill_vram(MODE2_ATTR + map_block(8, 8), 0x1A, 8 * 18, 18, 256);

	x = 0; y = 0;

	// preview loop
	while (!get_trigger(0)) {
		// move the cursor and set the zooming
		st = st_dir[get_stick(0)];

		x += (st & st_right) ? 1 : ((st & st_left) ? -1 : 0);
		y += (st & st_down) ? 1 : ((st & st_up) ? -1 : 0);

		x &= 15;
		y &= 15;
		asc = (y << 4) + x;
		put_sprite_8(0, (x + 2) << 3, (y + 2) << 3, 0, 9);

		preview_char(buf + (asc << 3));
	}	
}

main(int argc, char *argv[]) {
	FILE* f;
	bool preview;
	u_char buf[MAX_BUF];

	// bouring argv stuff
	if (!--argc) {
		printf("Usage: ex8 [-]file.alf\n");
		printf("\t- : preview mode\n");
		printf("file must be of type GRAPHOS ALPHABET (.ALF)\n");
		return 1;
	}

	preview = false;

	//++argv;
	if (*(argv[1]) == '-') {
		(argv[1])++;
		preview = true;
		printf("preview mode on\n");
	}

	// read file
	f = fopen(argv[1], "rb");

	if (!f) {
		printf("couldn't open file %s\n", argv[1]);
		return 2;
	}

	fseek(f, FILE_OFFS, SEEK_SET);

	/*
	fgetc(f);
	fgetc(f);
	fgetc(f);
	fgetc(f);
	fgetc(f);
	fgetc(f);
	fgetc(f);
	*/
	
	fread(buf + 8, 1, MAX_BUF - 8, f);
	fclose(f);

	buf[0]=buf[1]=buf[2]=buf[3]=buf[4]=buf[5]=buf[6]=buf[7]=0;

	// here is the thing: when not previewing, the vwrite will set
	// your whole char table with the given alphabet. nice :)

	set_mode((preview) ? mode_2 : mode_1);

	if (preview) {
		do_preview(buf);
		set_mode(mode_0);
	} else
		vwrite(buf + 8, VRAM_OFFS, MAX_BUF);
}
