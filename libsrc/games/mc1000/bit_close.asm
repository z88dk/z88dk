; $Id: bit_close.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close();
;
; Ensjo - 2013
;

    PUBLIC     bit_close

.bit_close
    ld    a,$07 ; Select PSG's mixer register.
    out    ($20),a
    ld    a,$7f ; All channels "silent"
              ; (and MC-1000's specific settings
              ; for IOA [output] and IOB [input]).
    out    ($60),a

    ret
