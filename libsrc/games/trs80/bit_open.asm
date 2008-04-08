; $Id: bit_open.asm,v 1.1 2008-04-08 16:49:27 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open
          ld   a,1
          ld   (snd_tick),a
          ret
