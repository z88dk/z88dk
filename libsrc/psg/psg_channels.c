/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set noise or tone generation on a group of channels (ORed bits)
	
	$Id: psg_channels.c,v 1.1 2013-11-15 07:26:41 stefano Exp $
*/

#include <psg.h>
void psg_channels(unsigned char tone_channels, unsigned char noise_channels) {
	set_psg(7, (tone_channels << 3) | noise_channels);
}
