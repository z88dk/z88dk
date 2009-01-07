/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Plays a tone on a channel
	
	$Id: msx_psg_tone.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_psg_tone(unsigned char channel, int period) {
	channel <<= 1;
	msx_set_psg(channel, period & 255);
	msx_set_psg(channel + 1, period >> 8);
}

