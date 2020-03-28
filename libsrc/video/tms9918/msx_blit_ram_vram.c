/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Blit - Under development
	
	$Id: msx_blit_ram_vram.c,v 1.4 2016-06-16 20:54:24 dom Exp $
*/

#include <msx.h>

void msx_blit_ram_vram(unsigned char* source, unsigned int dest, unsigned int w, unsigned int h, int sjmp, int djmp) {
	while (h--) {
		msx_vwrite_direct(source, dest, w);
		source += sjmp;
		dest += djmp;		
	}
}
