/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the envelope on a sound channel
	
	$Id: msx_psg_envelope.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_psg_envelope(unsigned char waveform, int period, unsigned char channels) {
	msx_set_psg(13, waveform);
	msx_set_psg(11, period & 255);
	msx_set_psg(12, period >> 8);
	if (channels & 1)
		msx_set_psg(8, 16);
	if (channels & 2)
		msx_set_psg(9, 16);
	if (channels & 4)
		msx_set_psg(10, 16);
	// FIXME: perhaps we should mute all others?
}
