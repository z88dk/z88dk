; $Id: bit_open.asm,v 1.4 2013-10-21 14:23:45 stefano Exp $
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
;	  ld a,(snd_tick)
        ld a,(23693)
        rra
        rra
        rra
        and 7
        or	8
        push de
        ld	e,a
        ld  a,(snd_tick)
        and sndbit_mask
        pop de
        or e
        ld	a,(snd_tick)
	  ret
