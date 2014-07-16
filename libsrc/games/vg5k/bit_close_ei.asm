; $Id: bit_close_ei.asm,v 1.1 2014-07-16 09:59:57 stefano Exp $
;
; VG-5000 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 2014
;

    XLIB	bit_close_ei
    XREF	bit_irqstatus

.bit_close_ei
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
