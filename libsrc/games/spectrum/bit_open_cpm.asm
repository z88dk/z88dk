; $Id: bit_open_cpm.asm,v 1.1 2016-10-31 07:08:06 stefano Exp $
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
    EXTERN     __snd_tick
	EXTERN	RG0SAV

.bit_open
._bit_open
        ld a,(RG0SAV)
        rra
        rra
        rra
        and 7
        or	8
        push de
        ld	e,a
        ld  a,(__snd_tick)
        and sndbit_mask
        or e
        pop de
        ld	(__snd_tick),a
	  ret
