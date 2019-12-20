;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_TestKey.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_TestKey
        PUBLIC    _cpc_TestKey
        
        EXTERN cpc_TestKeyboard
		;EXTERN cpc_KeysData
		EXTERN tabla_teclas

.cpc_TestKey
._cpc_TestKey

	sla l
	inc l
	ld h,0
	ld de,tabla_teclas
	add hl,de
	
	ld a,(hl)
	call cpc_TestKeyboard		; read the corresponding keyboard row
	DEC hl
	and (hl)					; we look for a single key in the row
	CP (hl)
	ld hl,0
	ret nz
	;pulsado
	inc l
	ret
