; $Id: bit_close_ei.asm,v 1.1 2008-12-09 17:48:18 stefano Exp $
;
; Galaksija 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato
;

    XLIB     bit_close_ei

.bit_close_ei
          ei
          ret

