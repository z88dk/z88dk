; $Id: bit_close_ei.asm,v 1.1 2003-02-04 09:10:17 stefano Exp $
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

