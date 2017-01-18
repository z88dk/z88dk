/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set screen to mangled mode (screen 1 + 2)
	
	$Id: msx_put_sprite_16.c,v 1.4 2016-06-16 20:54:24 dom Exp $
*/

#include <msx.h>

void msx_put_sprite_16(unsigned int id, int x, int y, unsigned int handle, unsigned int color) {
	sprite_t sp;
	if (x < 0) {
		x += 32;
		color |= 128;
	}
	sp.y = y - 1;
	sp.x = x;
	sp.handle = (handle << 2);
	sp.color = color;
	msx_vwrite_direct(&sp, 6912 + (id << 2), 4);
}
