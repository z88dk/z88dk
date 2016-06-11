; $Id: bit_close_ei.asm,v 1.4 2016-06-11 20:52:26 dom Exp $
;
; VZ 200 - 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 31/03/2008
;

    PUBLIC     bit_close_ei
    EXTERN     __bit_irqstatus

.bit_close_ei

	push hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
