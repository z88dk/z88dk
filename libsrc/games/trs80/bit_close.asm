; $Id: bit_close.asm,v 1.1 2008-04-08 16:49:27 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_close

.bit_close
          xor  a
          out  ($ff),a
          ret

