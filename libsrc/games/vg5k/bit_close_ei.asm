; $Id: bit_close_ei.asm,v 1.4 2016-06-16 19:33:59 dom Exp $
;
; VG-5000 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 2014
;

        SECTION code_clib
    PUBLIC	bit_close_ei
    PUBLIC	_bit_close_ei
    EXTERN	__bit_irqstatus

.bit_close_ei
._bit_close_ei
	push hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
