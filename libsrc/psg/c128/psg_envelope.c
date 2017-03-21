/*

	C128 specific routines
	YM PSG emulation - Stefano Bodrato, 2017
	
	Set the envelope on a sound channel
	
	$Id: psg_envelope.c,   stefano Exp $
*/

#include <psg.h>
#include <c128/sid.h>

void psg_envelope(unsigned char waveform, int period, unsigned char channels)
{
	// Voice, Attack, Decay, Sustain, Release
	switch (waveform) {

	case envUH:
	case envUU:
		if (channels & 1)
			envelopesid(sidVoice1,period/13,0,period/13,0);
		if (channels & 2)
			envelopesid(sidVoice2,period/13,0,period/13,0);
		if (channels & 4)
			envelopesid(sidVoice3,period/13,0,period/13,0);
		break;
		
//	case envD:
//	case envDD:
	default:
		if (channels & 1)
			envelopesid(sidVoice1,0,period/13,0,period/13);
		if (channels & 2)
			envelopesid(sidVoice2,0,period/13,0,period/13);
		if (channels & 4)
			envelopesid(sidVoice3,0,period/13,0,period/13);
		break;
	}
}

