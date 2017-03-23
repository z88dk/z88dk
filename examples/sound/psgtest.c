/*
;
;  Emulating bit_play with the PSG (no real poliphony!)
;  play a melody (integer approx to optimize speed and size)
;
;  by Stefano Bodrato - 2017
;
;  Syntax: "TONE(#/b)(+/-)(duration)"
;
*/

#include <psg.h>
#include <sound.h>
#include <time.h>
#include <stdlib.h>

void psg_play(unsigned char melody[])
{
int sound;
int duration=2;
float x;


while ( *melody != 0 )
   {
   switch (*melody++) {
	case 'C':
		if (*melody=='#') {
			sound=277;
			melody++;
			}
		else
			sound=262;
	break;
	case 'D':
		if (*melody=='#') {
			sound=311;
			melody++;
			}
		else if (*melody=='b') {
			sound=277;
			melody++;
			}
		else
			sound=294;
	break;
	case 'E':
		if (*melody=='b') {
			sound=311;
			melody++;
			}
		else
			sound=330;
	break;
	case 'F':
		if (*melody=='#') {
			sound=370;
			melody++;
			}
		else
			sound=349;
	break;
	case 'G':
		if (*melody=='#') {
			sound=415;
			melody++;
			}
		else if (*melody=='b') {
			sound=370;
			melody++;
			}
		else
			sound=392;
	break;
	case 'A':
		if (*melody=='#') {
			sound=466;
			melody++;
			}
		else if (*melody=='b') {
			sound=415;
			melody++;
			}
		else
			sound=440;
	break;
	case 'B':
		if (*melody=='b') {
			sound=466;
			melody++;
			}
		else
			sound=494;
	break;
	case '+':
		sound*=2;
	break;
	case '-':
		sound/=2;
	}
	if (*melody>'0' && *melody<='9') duration=(*melody++)-48;
	if ((*melody >= 'A' && *melody <= 'H') || *melody==0) {
		psg_tone(0, psgT(sound));
		psg_tone(1, psgT(sound/2));
		psg_tone(2, psgT(sound*2));
		delay (120*duration);
		//for (x=0.0; x<BEEP_TSTATES/40000.0*duration; x++) { }
		psg_tone(0, 0);
		psg_tone(1, 0);
		psg_tone(2, 0);
	}
   }
}


int main () {
	psg_init();
	psg_channels(chanAll, chanNone); // set all channels to tone generation
		psg_volume(0,10);
		psg_volume(1,10);
		psg_volume(2,10);

// Fra Martino
	psg_play("C4DECCDECEFG8E4FG8G2AGFE4CG2AGFE4CDG-CCDG-CC");

// ZX DEMO
	psg_play("C8DEb4DC8");
	psg_play("C8DEb4DC8");
	psg_play("Eb8FGG");
	psg_play("Eb8FGG");
	psg_play("G8Ab4G8FEb4DC");
	psg_play("G8Ab4G8FEb4DC");
	psg_play("C8G-C");
	psg_play("C8G-C");
}
