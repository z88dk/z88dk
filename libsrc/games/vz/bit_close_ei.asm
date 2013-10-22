; $Id: bit_close_ei.asm,v 1.2 2013-10-22 06:09:32 stefano Exp $
;
; VZ 200 - 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 31/03/2008
;

    XLIB     bit_close_ei
    XREF     bit_irqstatus

.bit_close_ei

	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
