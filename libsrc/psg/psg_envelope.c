/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the envelope on a sound channel
	
	$Id: psg_envelope.c,v 1.1 2013-11-15 07:26:41 stefano Exp $
*/

#include <psg.h>

void psg_envelope(unsigned char waveform, int period, unsigned char channels) {
	set_psg(13, waveform);
	set_psg(11, period & 255);
	set_psg(12, period >> 8);
	if (channels & 1)
		set_psg(8, 16);
	if (channels & 2)
		set_psg(9, 16);
	if (channels & 4)
		set_psg(10, 16);
	// FIXME: perhaps we should mute all others?
}
