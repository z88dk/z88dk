; $Id: bit_close_ei.asm,v 1.5 2013-10-22 07:18:26 stefano Exp $
;
; Z88 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 28/9/2001
; Based on the Dominic Morris' code
;

    XLIB     bit_close_ei
    INCLUDE  "interrpt.def"

    XREF     bit_irqstatus

    XREF     snd_asave

.bit_close_ei

	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

    ld   a,(snd_asave)

	ret po

	call oz_ei
	ret


