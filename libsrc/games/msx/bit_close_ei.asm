; $Id: bit_close_ei.asm,v 1.2 2013-10-21 14:23:45 stefano Exp $
;
; MSX bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 3/12/2007
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

