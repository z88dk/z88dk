/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the sprite handle with the shape from data (small size)
	
	$Id: msx_set_sprite_8.c,v 1.4 2016-06-16 20:54:25 dom Exp $
*/

#include <msx.h>

void msx_set_sprite_8(unsigned int handle, void* data) {
	msx_vwrite_direct(data, 14336 + (handle << 3), 8);
}
