/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	extern void vp_set_sprite_mode(unsigned char mode);
	
	Set the sprite mode
	
	$Id: msx_set_sprite_mode.c,v 1.3 2016-06-16 20:54:25 dom Exp $
*/

#include <video/tms99x8.h>

#pragma codeseg code_video_vdp
#pragma constseg rodata_video_vdp
#pragma bssseg bss_video_vdp
#pragma dataseg data_video_vdp

void vdp_set_sprite_mode(enum sprite_mode mode) {
	unsigned char m = vdp_get_reg(1);
	vdp_set_reg(1, (m & 0xFC) | mode);

	//_init_sprites();
}
