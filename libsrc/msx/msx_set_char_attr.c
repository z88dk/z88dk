/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set char \a c attributes, from \a attr, at the given screen map \a place
	
	$Id: msx_set_char_attr.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_set_char_attr(char c, void *attr, unsigned char place) {
	unsigned int addr = c;
	addr <<= 3;
	addr += MODE2_ATTR;

	if (place & place_1) msx_vwrite(attr, addr, 8);
	if (place & place_2) msx_vwrite(attr, (256 * 8) + addr, 8);
	if (place & place_3) msx_vwrite(attr, (256 * 8 * 2) + addr, 8);
}

