/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Plays a noise
	
	$Id: msx_psg_noise.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_psg_noise(unsigned char period) {
	msx_set_psg(6, period & 31);
}
