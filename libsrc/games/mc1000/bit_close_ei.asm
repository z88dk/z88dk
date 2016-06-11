; $Id: bit_close_ei.asm,v 1.4 2016-06-11 20:52:25 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close_ei();
;
; Ensjo - 2013
;


    PUBLIC     bit_close_ei
    EXTERN		bit_close
    EXTERN     __bit_irqstatus

.bit_close_ei
	call bit_close
	push hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret

