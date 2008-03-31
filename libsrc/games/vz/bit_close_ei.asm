; $Id: bit_close_ei.asm,v 1.1 2008-03-31 17:16:20 stefano Exp $
;
; VZ 200 - 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 31/03/2008
;

    XLIB     bit_close_ei

.bit_close_ei
          ei
          ret
