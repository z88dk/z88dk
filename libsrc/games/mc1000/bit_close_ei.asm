; $Id: bit_close_ei.asm,v 1.2 2013-10-21 14:23:45 stefano Exp $
;
; CCE MC-1000 bit sound functions
;
; void bit_close_ei();
;
; Ensjo - 2013
;


    XLIB     bit_close_ei
    LIB		bit_close
    XREF     bit_irqstatus

.bit_close_ei
	call bit_close
	push hl
	ld	hl,(bit_irqstatus)
	ex	(sp),hl
	pop af

	ret po

	ei
	ret

