/*

	C128 specific routines
	YM PSG emulation - Stefano Bodrato, 2017
	
	Plays a noise
	
	$Id: psg_noise.c,   stefano Exp $
*/

#include <psg.h>
#include <c128/sid.h>

void psg_noise(unsigned char period) {

	envelopesid(sidVoice3,0,3,0,0);
	freqsid(sidVoice3,period);
	attacksid(sidVoice3,sidWaveNoi);

}
