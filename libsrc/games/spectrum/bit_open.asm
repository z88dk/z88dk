; $Id: bit_open.asm,v 1.3 2010-05-15 01:20:58 dom Exp $
;
; ZX Spectrum 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 28/9/2001
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open
	  ld a,(snd_tick)
	  ret
