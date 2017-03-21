/*

	C128 specific routines
	YM PSG emulation - Stefano Bodrato, 2017
	
	Plays a tone on a channel
	
	$Id: psg_tone.c,   stefano Exp $
*/

#include <psg.h>
#include <c128/sid.h>

void psg_tone(unsigned char channels, int period) {

	if (channels & 1) {
		freqsid(sidVoice1,period);
		attacksid(sidVoice1,sidWaveTri);
	}
	
	if (channels & 2) {
		freqsid(sidVoice2,period);
		attacksid(sidVoice2,sidWaveTri);
	}

	if (channels & 4) {
		freqsid(sidVoice3,period);
		attacksid(sidVoice3,sidWaveTri);
	}

}

