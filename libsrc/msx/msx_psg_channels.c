/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set noise or tone generation on a group of channels (ORed bits)
	
	$Id: msx_psg_channels.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>
void msx_psg_channels(unsigned char tone_channels, unsigned char noise_channels) {
	msx_set_psg(7, (tone_channels << 3) | noise_channels);
}
