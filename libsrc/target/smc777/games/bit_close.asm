
	SECTION code_clib
	PUBLIC     bit_close_ei
	PUBLIC     _bit_close_ei
	PUBLIC     bit_close
	PUBLIC     _bit_close
	EXTERN     __bit_irqstatus

.bit_close_ei
._bit_close_ei
	push	hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop	af
	ret	po
	ei
bit_close:
_bit_close:
	ret
