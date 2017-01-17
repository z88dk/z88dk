/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Plays a tone on a channel
	
	$Id: psg_tone.c,v 1.1 2013-11-15 07:26:41 stefano Exp $
*/

#include <psg.h>

void psg_tone(unsigned char channel, int period) {
	channel <<= 1;
	set_psg(channel, period & 255);
	set_psg(channel + 1, period >> 8);
}

