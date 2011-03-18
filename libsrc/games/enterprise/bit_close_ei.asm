; $Id: bit_close_ei.asm,v 1.1 2011-03-18 07:12:41 stefano Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; (Close sound) and restore interrupts
;
; Stefano Bodrato - 2011
;

    XLIB     bit_close_ei

.bit_close_ei
	ei
	ret

