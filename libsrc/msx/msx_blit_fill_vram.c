/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Blit - Under development
	
	$Id: msx_blit_fill_vram.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_blit_fill_vram(unsigned int dest, unsigned char value, unsigned char w, unsigned char h, int djmp) {
	while (h--) {
		msx_vfill(dest, value, w);
		dest += djmp;		
	}
}

