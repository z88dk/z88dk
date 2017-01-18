/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	extern void msx_set_mangled_mode();
	
	Set screen to mangled mode (screen 1 + 2)
	
	$Id: msx_set_mangled_mode.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_set_mangled_mode() {
	msx_set_mode(mode_1);
	msx_set_mode(0x7E);
	msx_vwrite((void*)0x1BBF, 0x0800, 0x800);	
	msx_vwrite((void*)0x1BBF, 0x1000, 0x800);	
	msx_vfill(MODE2_ATTR, 0xF0, 0x17FF);
	msx_vfill(0xFF8, 0xFF, 8);
	msx_vfill(0x17F8, 0xFF, 8);

	//_init_sprites();
}

