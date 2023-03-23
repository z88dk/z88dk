/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the sprite handle with the shape from data (small size)
	
	$Id: msx_set_sprite_8.c,v 1.4 2016-06-16 20:54:25 dom Exp $
*/

#include <video/tms99x8.h>

#pragma codeseg code_video_vdp
#pragma constseg rodata_video_vdp
#pragma bssseg bss_video_vdp
#pragma dataseg data_video_vdp

void vdp_set_sprite_8(unsigned int handle, void* data) {
	vdp_vwrite_direct(data, _tms9918_sprite_generator + (handle << 3), 8);
}
