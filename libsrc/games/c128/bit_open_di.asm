; $Id: bit_open_di.asm,v 1.1 2008-07-11 15:10:57 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_open_di
    LIB      bit_open

.bit_open_di
	jp	bit_open
        ret
