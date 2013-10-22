; $Id: bit_close_ei.asm,v 1.2 2013-10-22 06:09:32 stefano Exp $
;
; TRS-80 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 8/4/2008
;

    XLIB     bit_close_ei
    XREF     bit_irqstatus

.bit_close_ei
          xor  a
          out  ($ff),a
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret
