; $Id: bit_close_ei.asm,v 1.1 2001-10-25 13:31:32 stefano Exp $
;
; TI calculator "Infrared port" 1 bit sound functions stub
;
; (Close sound) and restore interrupts
;
; Stefano Bodrato - 24/10/2001
;

    XLIB     bit_close_ei
    XREF     tiei

.bit_close_ei
	jp	tiei

