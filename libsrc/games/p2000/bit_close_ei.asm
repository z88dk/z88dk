; $Id: bit_close_ei.asm,v 1.3 2016-06-11 20:52:25 dom Exp $
;
; Philips P2000 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - Apr 2014
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
