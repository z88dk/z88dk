/*

	MSX specific routines

	GFX - a small graphics library 
	Copyright (C) 2004  Rafael de Oliveira Jannone

	Get the group of channels currently generating tone (ORed bits)
	
	$Id: msx_psg_tone_channels.c,v 1.1 2009-01-07 09:50:15 stefano Exp $
*/

#include <msx.h>

unsigned char msx_psg_tone_channels() {

	return (msx_psg_get(7) >> 3) & 7;

}
