; $Id: bit_open.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Generic 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2001..2013
;

    INCLUDE  "games/games.inc"

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open
	  ld a,(snd_tick)
	  ret
