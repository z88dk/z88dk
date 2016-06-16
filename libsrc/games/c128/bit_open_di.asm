; $Id: bit_open_di.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;
; TRS-80 1 bit sound functions
;
; Open sound and disable interrupts for exact timing
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_open_di
    PUBLIC     _bit_open_di
    EXTERN      bit_open

.bit_open_di
._bit_open_di
	jp	bit_open
