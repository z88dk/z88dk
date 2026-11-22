/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set screen to mangled mode (screen 1 + 2)
	
	$Id: msx_put_sprite_8.c,v 1.4 2016-06-16 20:54:24 dom Exp $
*/

#include <video/tms99x8.h>

#pragma codeseg code_video_vdp
#pragma constseg rodata_video_vdp
#pragma bssseg bss_video_vdp
#pragma dataseg data_video_vdp

void vdp_put_sprite_8(unsigned int id, int x, int y, unsigned int handle, unsigned int color) {
	sprite_t sp;
	if (x < 0) {
		x += 32;
		color |= 128;
	}
	sp.y = y - 1;
	sp.x = x;
	sp.handle = handle;
	sp.color = color;
	vdp_vwrite_direct(&sp, _tms9918_sprite_attribute + (id << 2), 4);
}
