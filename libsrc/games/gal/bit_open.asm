; $Id: bit_open.asm,v 1.2 2008-12-11 16:42:22 stefano Exp $
;
; Galaksija 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_open
    XREF     snd_tick

.bit_open
          ld   a,@10111000
          ld   (snd_tick),a
          ld   (8248),a
          ret
