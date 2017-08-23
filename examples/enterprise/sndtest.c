
/* 
 * Enterprise 64/128  Sound demo
 * 
 * Example on how to interface to EXOS with z88dk
 * communicates to the 'SOUND:' device via the ESCape sequences.
 * 
 * To build:
 * zcc +enterprise -create-app -lm sndtest.c
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <enterprise.h>
#include <math.h>

float a;
int b,c;


void main()
{	
	// Not necessary but.. who knows ?
	exos_close_channel(DEFAULT_SOUND);

	if (exos_open_channel(DEFAULT_SOUND,DEV_SOUND)) {
		printf("Error opening sound device");
	} else {

		// Flush all sound queues (optional)
		exos_write_character(DEFAULT_SOUND,26);

		// Flush all envelope storage (more than optional)
		exos_write_character(DEFAULT_SOUND,24);

		speaker_on();

		// Set escape cmd to play sound
		esccmd_cmd='S';

		for (c=10; c<=30; c+=10) {
			for (a=18.0; a<=46.0; a+=2.4) {
				for (b=10; b<=20; b+=2) {

					esccmd_env=255;    // No Envelope
					esccmd_p=(a+(float)b)*512.0;      // pitch (16 bit)
					esccmd_vl=200;   // pan sound
					esccmd_vr=50;    // on the left
					esccmd_sty=192;  // style
					esccmd_ch=0;     // 1st sound channel
					esccmd_d=5;      // duration (16 bit)
					esccmd_f=0;      // wait the end of sound
					exos_write_block(DEFAULT_SOUND, 12, esccmd);

					esccmd_p=512.0*(a+(float)b+(float)c-19.0);
					esccmd_vl=130;   // pan sound
					esccmd_vr=130;   // in the centre
					esccmd_sty=64;
					esccmd_ch=1;     // 2nd sound channel
					exos_write_block(DEFAULT_SOUND, 12, esccmd);

					esccmd_p=512.0*((a+(float)b)+12.0);
					esccmd_vl=50;    // pan sound
					esccmd_vr=200;   // on the right
					esccmd_sty=16;
					esccmd_ch=2;     // 2nd sound channel
					exos_write_block(DEFAULT_SOUND, 12, esccmd);

				}
			}
		}
	}

	while (getk()!=13) {};

	// BEL (CTRL-G)
	//exos_write_character(DEFAULT_SOUND, 7);

}
