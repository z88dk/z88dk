; $Id: bit_open_di.asm,v 1.1 2008-03-31 17:16:20 stefano Exp $
;
; VZ 200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 31/3/2008
;

    XLIB     bit_open_di
    XREF     snd_tick

.bit_open_di
          di
          ld    a,($783b)
          ld   (snd_tick),a
          ret
