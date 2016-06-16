; $Id: bit_close.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;
; MSX bit sound functions
;
; void bit_close();
;
; Stefano Bodrato - 3/12/2007
;

    SECTION code_clib
    PUBLIC     bit_close
    PUBLIC     _bit_close

.bit_close
._bit_close
          ei
          ret

