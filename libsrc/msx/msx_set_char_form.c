/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set char \a c shape, from \a form, at the given screen map \a place
	
	$Id: msx_set_char_form.c,v 1.2 2009-01-13 21:23:17 stefano Exp $
*/

#include <msx.h>

void msx_set_char_form(char c, void* form, unsigned char place) {
	unsigned int addr = c;
	addr <<= 3;
	if (place & place_1) msx_vwrite_direct(form, addr, 8);
	if (place & place_2) msx_vwrite_direct(form, (256 * 8) + addr, 8);
	if (place & place_3) msx_vwrite_direct(form, (256 * 8 * 2) + addr, 8);
}

