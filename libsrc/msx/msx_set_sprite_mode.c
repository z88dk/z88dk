/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	extern void msx_set_sprite_mode(unsigned char mode);
	
	Set the sprite mode
	
	$Id: msx_set_sprite_mode.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_set_sprite_mode(unsigned char mode) {
	unsigned char m = msx_get_vdp(1);
	msx_set_vdp(1, (m & 0xFC) | mode);

	//_init_sprites();
}
