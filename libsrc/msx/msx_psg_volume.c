/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Set the volume level on a sound channel
	
	$Id: msx_psg_volume.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

void msx_psg_volume(unsigned char channel, unsigned char volume) {
	msx_set_psg(channel + 8, volume & 15);
}
