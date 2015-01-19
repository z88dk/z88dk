; $Id: bit_close_ei.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; TRS-80 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_close_ei
    EXTERN      bit_close

.bit_close_ei
	jp	bit_close
