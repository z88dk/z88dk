; $Id: bit_close_ei.asm,v 1.1 2013-03-13 21:02:57 stefano Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close_ei();
;
; Ensjo - 2013
;

    XLIB     bit_close_ei
    LIB		bit_close

.bit_close_ei
          ei
          jp	bit_close

