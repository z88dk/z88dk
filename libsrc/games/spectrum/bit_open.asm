; $Id: bit_open.asm,v 1.5 2014-01-03 15:20:43 stefano Exp $
;
; ZX Spectrum 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 28/9/2001
;

    INCLUDE  "games/games.inc"

    XLIB     bit_open
    XREF     snd_tick

.bit_open
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
