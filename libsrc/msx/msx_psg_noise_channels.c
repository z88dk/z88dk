/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Get the group of channels currently generating noise (ORed bits)
	
	$Id: msx_psg_noise_channels.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

unsigned char msx_psg_noise_channels() {

	return msx_get_psg(7) & 7;

}

