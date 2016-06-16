; $Id: bit_open.asm,v 1.3 2016-06-16 19:33:59 dom Exp $
;
; VG-5000 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2014
;

    INCLUDE  "games/games.inc"

        SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
        ld a,8
        ld	(__snd_tick),a
	  ret
