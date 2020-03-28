/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Blit - Under development
	
	$Id: msx_blit.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>


void msx_blit(surface_t *source, surface_t *dest, rect_t *from, rect_t *to) {
	// one can always dream :)	
}

/* unfinished
void blit_ram_vram(surface_t *source, surface_t *dest, rect_t *from, rect_t *to) {

	int s_jmp, d_jmp, h;
	u_char* s_addr;
	u_int   d_addr;

	s_jmp = source->width - from->width;
	d_jmp = dest->width - from->width;
	h = from->height;

	s_addr = 0; // ?
	d_addr = 0; // ?
}
*/
