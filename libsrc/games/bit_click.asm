; $Id: bit_click.asm,v 1.4 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Generic 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 2/10/2001
;

    PUBLIC     bit_click
    INCLUDE  "games/games.inc"

    EXTERN     snd_tick

.bit_click

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

