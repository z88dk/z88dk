; $Id: bit_close_ei.asm,v 1.1 2001-10-22 09:33:55 stefano Exp $
;
; Jupiter ACE 1 bit sound functions
;
; (Close sound) and restore interrupts
;
; Stefano Bodrato - 18/10/2001
;

    XLIB     bit_close_ei

.bit_close_ei
          ei
          ret

