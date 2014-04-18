; $Id: bit_close_ei.asm,v 1.1 2014-04-18 07:38:58 stefano Exp $
;
; Philips P2000 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - Apr 2014
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
