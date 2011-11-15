; $Id: bit_open.asm,v 1.1 2011-11-15 16:40:47 stefano Exp $
;
; ZX81 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 11/11/2001
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open
	  xor a
	  ret
