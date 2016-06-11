; $Id: bit_open.asm,v 1.4 2016-06-11 20:52:25 dom Exp $
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
    EXTERN     __snd_tick

.bit_open
._bit_open
	  ld a,(__snd_tick)
	  ret
