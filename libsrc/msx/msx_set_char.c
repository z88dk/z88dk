/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set char \a c shape, attributes and color, all in one
	
	$Id: msx_set_char.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_set_char(char c, void* form, void *attr, unsigned char color, unsigned char place) {
	msx_set_char_form(c, form, place);
	if (attr)
		msx_set_char_attr(c, attr, place);
	else
		msx_set_char_color(c, color, place);
}

