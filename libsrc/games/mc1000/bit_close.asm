; $Id: bit_close.asm,v 1.1 2013-03-13 21:02:57 stefano Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close();
;
; Ensjo - 2013
;

    XLIB     bit_close

.bit_close
    ld    a,$07 ; Select PSG's mixer register.
    out    ($20),a
    ld    a,$7f ; All channels "silent"
              ; (and MC-1000's specific settings
              ; for IOA [output] and IOB [input]).
    out    ($60),a

    ret
