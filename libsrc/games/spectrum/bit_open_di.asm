; $Id: bit_open_di.asm,v 1.3 2010-05-15 01:20:58 dom Exp $
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
          ld  a,(snd_tick)
          ret
