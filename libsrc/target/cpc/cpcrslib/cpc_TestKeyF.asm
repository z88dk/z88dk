;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_TestKeyF.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_TestKeyF
        PUBLIC    _cpc_TestKeyF
        
		;EXTERN cpc_KeysData
        EXTERN keymap
		EXTERN tabla_teclas
		
.cpc_TestKeyF
._cpc_TestKeyF
	SLA L
	inc l
	ld h,0
	ld de,tabla_teclas
	add hl,de
	
	ld a,(HL)
	sub $40

	ex de,hl
	ld hl,keymap	;; lee la línea buscada del keymap
	ld c,a
	ld b,0
	add hl,bc
	ld a,(hl)
	ex de,hl

	DEC hl		; pero sólo nos interesa una de las teclas.
	and (HL)    ; para filtrar por el bit de la tecla (puede haber varias pulsadas)
	CP (hl)     ; comprueba si el byte coincide
	ld hl,0
	ret z
	inc l
	ret
