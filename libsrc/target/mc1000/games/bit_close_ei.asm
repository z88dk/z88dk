; $Id: bit_close_ei.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close_ei();
;
; Ensjo - 2013
;

    SECTION code_clib
    PUBLIC     bit_close_ei
    PUBLIC     _bit_close_ei
    EXTERN		bit_close
    EXTERN     __bit_irqstatus

.bit_close_ei
._bit_close_ei
	call bit_close
	push hl
	ld	hl,(__bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret

