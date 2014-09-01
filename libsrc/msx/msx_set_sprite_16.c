/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the sprite handle with the shape from data (big size)
	
	$Id: msx_set_sprite_16.c,v 1.4 2014-09-01 03:14:09 aralbrec Exp $
*/

#include <msx.h>

void msx_set_sprite_16(unsigned char handle, void* data) {
	msx_vwrite_direct(data, 14336 + (handle << 5), 32);
}
