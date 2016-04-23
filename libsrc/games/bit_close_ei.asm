; $Id: bit_close_ei.asm,v 1.3 2016-04-23 21:06:32 dom Exp $
;
; Generic 1 bit sound functions
;
; Close sound and restore the previous
; interrupt status
;
; Stefano Bodrato - 2001..2013
;

    SECTION    code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei
    EXTERN     bit_irqstatus

.bit_close_ei
._bit_close_ei
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret

