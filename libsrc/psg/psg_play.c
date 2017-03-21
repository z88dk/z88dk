/*
; $Id: psg_play.c -  Stefano, 20/03/2017$
;
; Emulating bit_play with the PSG (no poliphony!)
; play a melody (integer approx to optimize speed and size)
;
; Stefano Bodrato 2017
;
; Syntax: "TONE(#/b)(+/-)(duration)"
; Sample:
;		bit_play("C8DEb4DC8");
;		bit_play("C8DEb4DC8");
;		bit_play("Eb8FGG");
;		bit_play("Eb8FGG");
;		bit_play("G8Ab4G8FEb4DC");
;		bit_play("G8Ab4G8FEb4DC");
;		bit_play("C8G-C");
;		bit_play("C8G-C");
*/

#include <psg.h>
#include <sound.h>

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
		//bit_beep ( (double)(sound*duration)/12., (BEEP_TSTATES/(double)sound)-30. );
		psg_tone(chanAll, sound);
		for (x=0.0; x< BEEP_TSTATES/10000.0; x++) {}
	}	
   }
}
