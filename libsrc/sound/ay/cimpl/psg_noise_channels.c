/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Get the group of channels currently generating noise (ORed bits)
	
	$Id: psg_noise_channels.c,v 1.1 2013-11-15 07:26:41 stefano Exp $
*/

#include <psg.h>

unsigned char psg_noise_channels() {

	return get_psg(7) & 7;

}

