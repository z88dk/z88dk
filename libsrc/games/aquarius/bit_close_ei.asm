; $Id: bit_close_ei.asm,v 1.2 2002-04-17 21:30:24 dom Exp $
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

