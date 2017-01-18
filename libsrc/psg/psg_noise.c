/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Plays a noise
	
	$Id: psg_noise.c,v 1.1 2013-11-15 07:26:41 stefano Exp $
*/

#include <psg.h>

void psg_noise(unsigned char period) {
	set_psg(6, period & 31);
}
