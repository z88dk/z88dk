/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set char \a c with \a color, at the given screen map \a place
	
	$Id: vdp_set_char_color.c,v 1.2 2016-06-16 20:54:24 dom Exp $
*/

#include <video/tms99x8.h>

#pragma codeseg code_video_vdp
#pragma constseg rodata_video_vdp
#pragma bssseg bss_video_vdp
#pragma dataseg data_video_vdp

void vdp_set_char_color(int c, unsigned int color, unsigned int place) {
	unsigned int addr = c;
	addr <<= 3;
	addr += MODE2_ATTR;

	if (place & place_1) vdp_vfill(addr, color, 8);
	if (place & place_2) vdp_vfill((256 * 8) + addr, color, 8);
	if (place & place_3) vdp_vfill((256 * 8 * 2) + addr, color, 8);
}

