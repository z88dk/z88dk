/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the volume level on a sound channel
	
	$Id: psg_volume.c,v 1.1 2013-11-15 07:26:41 stefano Exp $
*/

#include <psg.h>

void psg_volume(unsigned char channel, unsigned char volume) {
	set_psg(channel + 8, volume & 15);
}
