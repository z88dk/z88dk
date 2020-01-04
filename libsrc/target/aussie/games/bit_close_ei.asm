; $Id: bit_close_ei.asm,v 1.1 2016-11-15 11:43:52 stefano Exp $
;
; Aussie Byte 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 2016
;

    SECTION code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei
    EXTERN     __bit_irqstatus

.bit_close_ei
._bit_close_ei
	push hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
