/*
; $Id: synth_play.c $
;
; Generic 1 bit sound functions
; play a melody with bit_synth (integer approx to optimize speed and size)
; use synth_phase(0x1234) to slightly alter the 4 voices freq. shifting
;
; Stefano Bodrato 2021
;
; Syntax: "TONE(#/b)(+/-)(duration)"
; Sample:
;		synth_play("C8DEb4DC8");
;		synth_play("C8DEb4DC8");
;		synth_play("Eb8FGG");
;		synth_play("Eb8FGG");
;		synth_play("G8Ab4G8F4Eb4DC");
;		synth_play("G8Ab4G8F4Eb4DC");
;		synth_play("C8GC");
;		synth_play("C8GGC");
*/

#include <sound.h>

/* Frequency bias to "tune" bit_synth properly */
#define SYNTH_CONST 8.0

void synth_play(char melody[])
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
	if (*melody>'0' && *melody<='9') duration=(*melody++)-48;
	if ((*melody >= 'A' && *melody <= 'H') || *melody==0)
		//bit_beep ( (double)(sound*duration)/12., (BEEP_TSTATES/(double)sound)-30. );
		bit_synth ( (double)(sound*duration)/46., ((BEEP_TSTATES/SYNTH_CONST)/(double)sound)-(double)synth_phase_1,(BEEP_TSTATES/(SYNTH_CONST*(double)sound))-(double)synth_phase_2,(BEEP_TSTATES/(SYNTH_CONST*(double)sound))-(double)synth_phase_3,(BEEP_TSTATES/(SYNTH_CONST*(double)sound))-(double)synth_phase_4);
#ifdef __ZX81__
	bit_open_di();
#endif
   }
#ifdef __ZX81__
   bit_close_ei();
#endif
}
