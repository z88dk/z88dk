; $Id: bit_close_ei.asm,v 1.1 2013-10-21 14:23:45 stefano Exp $
;
; Generic 1 bit sound functions
;
; Close sound and restore the previous
; interrupt status
;
; Stefano Bodrato - 2001..2013
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

