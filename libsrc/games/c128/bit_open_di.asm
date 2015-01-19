; $Id: bit_open_di.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; TRS-80 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_open_di
    EXTERN      bit_open

.bit_open_di
	jp	bit_open
        ret
