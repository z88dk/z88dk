/*

	C128 specific routines
	YM PSG emulation - Stefano Bodrato, 2017
	
	Set the volume level on a sound channel
	
	$Id: psg_volume.c,   stefano Exp $
*/



#include <psg.h>
#include <c128/sid.h>

void psg_volume(unsigned char channel, unsigned char volume) {
	volumesid(volume*15/10,0);
}
