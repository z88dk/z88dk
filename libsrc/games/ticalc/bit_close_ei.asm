; $Id: bit_close_ei.asm,v 1.5 2015-01-19 01:32:45 pauloscustodio Exp $
;
; TI calculator "Infrared port" 1 bit sound functions stub
;
; (Close sound) and restore interrupts
;
; Stefano Bodrato - 24/10/2001
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
