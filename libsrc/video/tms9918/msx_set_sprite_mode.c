/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	extern void msx_set_sprite_mode(unsigned char mode);
	
	Set the sprite mode
	
	$Id: msx_set_sprite_mode.c,v 1.3 2016-06-16 20:54:25 dom Exp $
*/

#include <msx.h>

void msx_set_sprite_mode(unsigned int mode) {
	unsigned char m = get_vdp_reg(1);
	set_vdp_reg(1, (m & 0xFC) | mode);

	//_init_sprites();
}
