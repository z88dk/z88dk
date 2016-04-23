; $Id: bit_open.asm,v 1.3 2016-04-23 21:06:32 dom Exp $
;
; Generic 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2001..2013
;

    INCLUDE  "games/games.inc"
    SECTION    code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     snd_tick

.bit_open
._bit_open
	  ld a,(snd_tick)
	  ret
