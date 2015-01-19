; $Id: bit_open.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open();
;
; Ensjo - 2013
;

    PUBLIC     bit_open
    EXTERN      bit_close
    EXTERN     snd_tick

.bit_open
    ;di
    call	bit_close

    ld    a,8 ; Select amplitude register for channel A.
    out   ($20),a
    xor   a
    ld    (snd_tick),a

    ret
