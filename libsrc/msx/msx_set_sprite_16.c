/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the sprite handle with the shape from data (big size)
	
	$Id: msx_set_sprite_16.c,v 1.2 2009-01-13 21:23:17 stefano Exp $
*/

#include <msx.h>

void msx_set_sprite_16(unsigned char handle, void* data) {
	msx_vwrite_direct(data, 14336 + (handle << 5), 32);
}
