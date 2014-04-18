; $Id: bit_open.asm,v 1.1 2014-04-18 07:38:58 stefano Exp $
;
; Philips P2000 1 bit sound functions
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - Apr 2014
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open
          ld   a,1
          ld   (snd_tick),a
          ret
