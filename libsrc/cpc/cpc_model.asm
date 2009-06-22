;
; int cpc_model();
; 
; Results:
;    0 - 464
;    1 - 664
;    2 - 6128


; $Id: cpc_model.asm,v 1.3 2009-06-22 21:44:16 dom Exp $


        INCLUDE "cpcfirm.def"              

        XDEF cpc_model

.cpc_model
	call	firmware
	defb	kl_probe_rom	; 0B915H
	ld	a,h		; version
	ld	hl,1
	rra
	ret	c	; 664
	ld	l,2
	rra
	ret	c	; 6128
	ld	l,h
	ret		; 464
