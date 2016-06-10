; $Id: bit_open.asm,v 1.7 2016-06-10 21:37:10 dom Exp $
;
; ZX Spectrum 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 28/9/2001
;

    INCLUDE  "games/games.inc"

    SECTION    code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     snd_tick

.bit_open
._bit_open
        ld a,(23624)
        rra
        rra
        rra
        and 7
        or	8
        push de
        ld	e,a
        ld  a,(snd_tick)
        and sndbit_mask
        or e
        pop de
        ld	(snd_tick),a
	  ret
