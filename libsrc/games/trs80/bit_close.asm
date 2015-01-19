; $Id: bit_close.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_close

.bit_close
          xor  a
          out  ($ff),a
          ret

