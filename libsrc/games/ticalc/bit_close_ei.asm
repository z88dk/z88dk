; $Id: bit_close_ei.asm,v 1.3 2002-04-17 21:30:24 dom Exp $
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
	ei
	ret

