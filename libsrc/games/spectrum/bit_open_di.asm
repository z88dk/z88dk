; $Id: bit_open_di.asm,v 1.1 2001-10-16 18:03:03 dom Exp $
;
; ZX Spectrum 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 28/9/2001
;

    XLIB     bit_open_di
    XREF     snd_tick

.bit_open_di
          di
          ld    a,(23624)  
          rrca
          rrca
          rrca
          or	8
          ld   (snd_tick),a
          ret
