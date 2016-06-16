; $Id: bit_open.asm,v 1.4 2016-06-16 19:33:59 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open();
;
; Ensjo - 2013
;

    PUBLIC     bit_open
    EXTERN      bit_close
    EXTERN     __snd_tick

.bit_open
    ;di
    call	bit_close

    ld    a,8 ; Select amplitude register for channel A.
    out   ($20),a
    xor   a
    ld    (__snd_tick),a

    ret
