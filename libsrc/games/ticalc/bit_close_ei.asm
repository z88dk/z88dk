; $Id: bit_close_ei.asm,v 1.4 2013-10-22 06:09:32 stefano Exp $
;
; TI calculator "Infrared port" 1 bit sound functions stub
;
; (Close sound) and restore interrupts
;
; Stefano Bodrato - 24/10/2001
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
