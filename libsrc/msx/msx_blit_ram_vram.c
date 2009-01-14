/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Blit - Under development
	
	$Id: msx_blit_ram_vram.c,v 1.2 2009-01-14 07:07:21 stefano Exp $
*/

#include <msx.h>

void msx_blit_ram_vram(unsigned char* source, unsigned int dest, unsigned char w, unsigned char h, int sjmp, int djmp) {
	while (h--) {
		msx_vwrite_direct(source, dest, w);
		source += sjmp;
		dest += djmp;		
	}
}
