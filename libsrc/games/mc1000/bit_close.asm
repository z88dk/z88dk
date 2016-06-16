; $Id: bit_close.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close();
;
; Ensjo - 2013
;

    SECTION code_clib
    PUBLIC     bit_close
    PUBLIC     _bit_close

.bit_close
._bit_close
    ld    a,$07 ; Select PSG's mixer register.
    out    ($20),a
    ld    a,$7f ; All channels "silent"
              ; (and MC-1000's specific settings
              ; for IOA [output] and IOB [input]).
    out    ($60),a

    ret
