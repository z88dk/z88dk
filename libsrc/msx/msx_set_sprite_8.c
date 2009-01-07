/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the sprite handle with the shape from data (small size)
	
	$Id: msx_set_sprite_8.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_set_sprite_8(unsigned char handle, void* data) {
	msx_vwrite(data, 14336 + (handle << 3), 8);
}
