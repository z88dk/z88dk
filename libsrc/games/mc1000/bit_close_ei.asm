; $Id: bit_close_ei.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close_ei();
;
; Ensjo - 2013
;


    PUBLIC     bit_close_ei
    EXTERN		bit_close
    EXTERN     bit_irqstatus

.bit_close_ei
	call bit_close
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret

