; $Id: bit_open_di.asm,v 1.1 2013-03-13 21:02:57 stefano Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_open_di();
;
; Ensjo - 2013
;

    XLIB     bit_open_di
    LIB		bit_open

.bit_open_di
    di
    jp	bit_open
