/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set screen to mangled mode (screen 1 + 2)
	
	$Id: msx_put_sprite_8.c,v 1.2 2009-01-14 07:07:21 stefano Exp $
*/

#include <msx.h>

void msx_put_sprite_8(unsigned char id, int x, int y, unsigned char handle, unsigned char color) {
	sprite_t sp;
	if (x < 0) {
		x += 32;
		color |= 128;
	}
	sp.y = y - 1;
	sp.x = x;
	sp.handle = handle;
	sp.color = color;
	msx_vwrite_direct(&sp, 6912 + (id << 2), 4);
}
