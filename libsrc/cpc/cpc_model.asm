;
; int cpc_model();
; 
; Results:
;    0 - 464
;    1 - 664
;    2 - 6128


; $Id: cpc_model.asm,v 1.7 2016-06-10 21:12:36 dom Exp $


        INCLUDE "cpcfirm.def"              

        SECTION   code_clib
        PUBLIC cpc_model
        PUBLIC _cpc_model

.cpc_model
._cpc_model
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
