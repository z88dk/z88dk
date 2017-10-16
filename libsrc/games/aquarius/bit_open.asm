; $Id: bit_open.asm $
;
; Aquarius 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2017
;

    INCLUDE  "games/games.inc"

        SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
        xor a
        ld	(__snd_tick),a
	  ret
