; $Id: bit_close_ei.asm,v 1.1 2001-12-28 09:46:28 stefano Exp $
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

