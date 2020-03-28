/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Blit - Under development
	
	$Id: msx_blit_fill_vram.c,v 1.2 2016-06-16 20:54:24 dom Exp $
*/

#include <msx.h>

void msx_blit_fill_vram(unsigned int dest, unsigned int value, unsigned int w, unsigned int h, int djmp) {
	while (h--) {
		msx_vfill(dest, value, w);
		dest += djmp;		
	}
}

