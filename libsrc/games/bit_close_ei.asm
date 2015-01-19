; $Id: bit_close_ei.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Generic 1 bit sound functions
;
; Close sound and restore the previous
; interrupt status
;
; Stefano Bodrato - 2001..2013
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

