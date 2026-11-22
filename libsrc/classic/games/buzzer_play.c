/*
; $Id: buzzer_play.c $
;
; Generic 1 bit sound functions
; play a melody (integer approx to optimize speed and size)
;
; Stefano Bodrato 11/10/2001
;
; Syntax: "TONE(#/b)(+/-)(duration)"
; Sample:
;		buzzer_play("C8DEb4DC8");
;		buzzer_play("C8DEb4DC8");
;		buzzer_play("Eb8FGG");
;		buzzer_play("Eb8FGG");
;		buzzer_play("G8Ab4G8FEb4DC");
;		buzzer_play("G8Ab4G8FEb4DC");
;		buzzer_play("C8G-C");
;		buzzer_play("C8G-C");
*/

#include <sound.h>

void buzzer_play(char *soundpatch, char *melody)
{
int sound;
int duration=2;

#ifdef __ZX81__
	bit_open_di();
#endif

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
	sound*=2;	// Let's move to an higher octave for patch_beep(), so the pattern is more granular
	
	if (*melody>'0' && *melody<='9') duration=(*melody++)-'0';
	if ((*melody >= 'A' && *melody <= 'H') || *melody==0)
		//bit_beep ( (double)(sound*duration)/12., (BEEP_TSTATES/(double)sound)-30. );
		patch_beep ( (double)(sound*duration)/6., (BEEP_TSTATES/(double)sound)-30., soundpatch );
#ifdef __ZX81__
	bit_open_di();
#endif
   }
#ifdef __ZX81__
   bit_close_ei();
#endif
}
