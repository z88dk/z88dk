; $Id: bit_close_ei.asm,v 1.1 2008-07-11 15:10:57 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_close_ei
    LIB      bit_close

.bit_close_ei
	jp	bit_close
