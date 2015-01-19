; $Id: bit_close_ei.asm,v 1.3 2015-01-19 01:32:45 pauloscustodio Exp $
;
; TRS-80 1 bit sound functions
;
; Close sound and restore interrupts
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_close_ei
    EXTERN     bit_irqstatus

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
