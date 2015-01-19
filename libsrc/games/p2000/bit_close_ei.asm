; $Id: bit_close_ei.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Philips P2000 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - Apr 2014
;

    PUBLIC     bit_close_ei
    EXTERN     bit_irqstatus

.bit_close_ei
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
