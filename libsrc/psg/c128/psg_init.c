/*

	C128 specific routines
	YM PSG emulation - Stefano Bodrato, 2017
	
	Set the envelope on a sound channel
	
	$Id: psg_init.c,   stefano Exp $
*/

#include <psg.h>
#include <c128/sid.h>

void psg_init()
{
	clearsid();
	volumesid(15,0);

}

