; $Id: bit_close_ei.asm,v 1.7 2016-04-23 21:06:32 dom Exp $
;
; Z88 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    SECTION   code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei
    INCLUDE  "interrpt.def"

    EXTERN     bit_irqstatus

    EXTERN     snd_asave

.bit_close_ei
._bit_close_ei

	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

    ld   a,(snd_asave)

	ret po

	jp  oz_ei


