; $Id: bit_click.asm,v 1.5 2016-04-23 21:06:32 dom Exp $
;
; Generic 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 2/10/2001
;

    SECTION    code_clib
    PUBLIC     bit_click
    PUBLIC     _bit_click
    INCLUDE  "games/games.inc"

    EXTERN     snd_tick

.bit_click
._bit_click

          ld   a,(snd_tick)
          xor  sndbit_mask

        IF sndbit_port > 255
          ld   bc,sndbit_port
          out  (c),a
        ELSE
          out  (sndbit_port),a
        ENDIF

          ld   (snd_tick),a
          ret

