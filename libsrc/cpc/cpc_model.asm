;
; int cpc_model();
; 
; Results:
;    0 - 464
;    1 - 664
;    2 - 6128


; $Id: cpc_model.asm,v 1.6 2015-01-19 01:32:42 pauloscustodio Exp $


        INCLUDE "cpcfirm.def"              

        PUBLIC cpc_model

.cpc_model
	call	firmware
	defw	kl_probe_rom	; 0B915H
	ld	a,h		; version
	ld	hl,1
	rra
	ret	c	; 664
	ld	l,2
	rra
	ret	c	; 6128
	ld	l,h
	ret		; 464
