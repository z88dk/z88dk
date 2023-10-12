; $Id: bit_click.asm,v 1.6 2016-06-11 20:52:25 dom Exp $
;
; Generic 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 2/10/2001
;

  IF    !__CPU_GBZ80__

        SECTION code_clib
        PUBLIC  bit_click
        PUBLIC  _bit_click
        INCLUDE "games/games.inc"

        EXTERN  __snd_tick

bit_click:
_bit_click:
        ld      a, (__snd_tick)
        xor     SOUND_ONEBIT_mask
        ld      (__snd_tick), a
        ONEBITOUT
        ret

  ENDIF
