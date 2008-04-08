; $Id: bit_open_di.asm,v 1.1 2008-04-08 16:49:27 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_open_di
    XREF     snd_tick

.bit_open_di
          ld   a,1
          ld   (snd_tick),a
          ;di
          ret
