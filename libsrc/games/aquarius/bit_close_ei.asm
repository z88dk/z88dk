; $Id: bit_close_ei.asm,v 1.1 2002-01-26 14:56:14 stefano Exp $
;
; Mattel Aquarius 1 bit sound functions
;
; (Close sound) and restore interrupts
;
; Stefano Bodrato - Dec 2001
;

    XLIB     bit_close_ei

.bit_close_ei
          ei
          ret

