; $Id: bit_close_ei.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;
; TRS-80 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei
    EXTERN      bit_close

.bit_close_ei
._bit_close_ei
	jp	bit_close
