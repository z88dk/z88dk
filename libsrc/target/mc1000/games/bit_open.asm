; $Id: bit_open.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open();
;
; Ensjo - 2013
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN      bit_close
    EXTERN     __snd_tick

.bit_open
._bit_open
    ;di
    call	bit_close

    ld    a,8 ; Select amplitude register for channel A.
    out   ($20),a
    xor   a
    ld    (__snd_tick),a

    ret
