/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	extern void vdp_set_mangled_mode();
	
	Set screen to mangled mode (screen 1 + 2)
	
	$Id: vdp_set_mangled_mode.c $
*/

#include <msx.h>

#ifdef __SVI__
char blank_char[8]={0,0,0,0,0,0,0,0};
#endif

void vdp_set_mangled_mode() {

	vdp_set_mode(mode_1);

#ifdef __SVI__
	vdp_set_mode(0x3629);
#else
	vdp_set_mode(0x7E);   //_SETGRP
#endif

	vdp_vwrite((void*)0x1BBF, 0x0800, 0x800);	
	vdp_vwrite((void*)0x1BBF, 0x1000, 0x800);	
	vdp_vfill(MODE2_ATTR, 0xF0, 0x17FF);
	vdp_vfill(0xFF8, 0xFF, 8);
	vdp_vfill(0x17F8, 0xFF, 8);
	
#ifdef __SVI__
	msx_set_char(0, blank_char, blank_char, 0, place_all);
	//vdp_vfill(0x1800, 0, 32*24);
#endif
	//_init_sprites();
}

