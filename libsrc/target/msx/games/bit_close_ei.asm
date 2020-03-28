; $Id: bit_close_ei.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;
; MSX bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 3/12/2007
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

