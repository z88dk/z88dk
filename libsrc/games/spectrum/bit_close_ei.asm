; $Id: bit_close_ei.asm,v 1.1 2001-10-16 18:03:03 dom Exp $
;
; ZX Spectrum 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 28/9/2001
;

    XLIB     bit_close_ei

.bit_close_ei
          ei
          ret

