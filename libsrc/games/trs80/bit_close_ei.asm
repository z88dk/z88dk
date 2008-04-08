; $Id: bit_close_ei.asm,v 1.1 2008-04-08 16:49:27 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_close_ei

.bit_close_ei
          xor  a
          out  ($ff),a
          ;ei
          ret

