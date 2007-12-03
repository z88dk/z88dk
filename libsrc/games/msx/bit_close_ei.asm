; $Id: bit_close_ei.asm,v 1.1 2007-12-03 16:05:19 stefano Exp $
;
; MSX bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 3/12/2007
;

    XLIB     bit_close_ei

.bit_close_ei
          ei
          ret

