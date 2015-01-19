; $Id: bit_close_ei.asm,v 1.6 2015-01-19 01:32:45 pauloscustodio Exp $
;
; Z88 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    PUBLIC     bit_close_ei
    INCLUDE  "interrpt.def"

    EXTERN     bit_irqstatus

    EXTERN     snd_asave

.bit_close_ei

	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

    ld   a,(snd_asave)

	ret po

	call oz_ei
	ret


