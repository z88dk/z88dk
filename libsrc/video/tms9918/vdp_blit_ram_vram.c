/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Blit - Under development
	
	$Id: vdp_blit_ram_vram.c,v 1.4 2016-06-16 20:54:24 dom Exp $
*/

#include <video/tms99x8.h>

#pragma codeseg code_video_vdp
#pragma constseg rodata_video_vdp
#pragma bssseg bss_video_vdp
#pragma dataseg data_video_vdp

void vdp_blit_ram_vram(unsigned char* source, unsigned int dest, unsigned int w, unsigned int h, int sjmp, int djmp) {
	while (h--) {
		vdp_vwrite_direct(source, dest, w);
		source += sjmp;
		dest += djmp;		
	}
}
