; $Id: bit_open.asm,v 1.1 2013-03-13 21:02:57 stefano Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open();
;
; Ensjo - 2013
;

    XLIB     bit_open
    LIB      bit_close
    XREF     snd_tick

.bit_open
    ;di
    call	bit_close

    ld    a,8 ; Select amplitude register for channel A.
    out    ($20),a
    ld		(snd_tick),a

    ret
