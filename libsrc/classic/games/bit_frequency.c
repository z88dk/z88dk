/*
; $Id: bit_frequency.c,v 1.3 2016-04-23 08:05:41 dom Exp $
;
; Generic 1 bit sound functions
; Beeps the right frequency
;
; Stefano Bodrato 8/10/2001
;

261.625565290         C
277.182631135         C#
293.664768100         D
311.126983881         D#
329.627557039         E
349.228231549         F
369.994422674         F#
391.995436072         G
415.304697513         G#
440.000000000         A
466.163761616         A#
493.883301378         B

*/

#include <sound.h>

void bit_frequency(float duration, float frequency)
{

  bit_beep ( (int) (frequency*duration), (int) ((BEEP_TSTATES/frequency)-29.5) );

}
