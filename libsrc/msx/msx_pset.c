/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set point at the given position on VRAM
	
	$Id: msx_pset.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_pset(int x, int y) {
	vmerge(map_pixel(x,y), map_subpixel(x));
}
