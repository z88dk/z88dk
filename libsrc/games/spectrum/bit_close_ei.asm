; $Id: bit_close_ei.asm,v 1.4 2015-01-19 01:32:45 pauloscustodio Exp $
;
; ZX Spectrum 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 28/9/2001
;

    PUBLIC	bit_close_ei
    EXTERN	bit_irqstatus

.bit_close_ei
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
