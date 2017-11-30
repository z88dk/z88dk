;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_DeleteKeys.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_DeleteKeys
        PUBLIC    _cpc_DeleteKeys
        
;        EXTERN cpc_KeysData
		EXTERN tabla_teclas

		;borra la tabla de las teclas para poder redefinirlas todas


.cpc_DeleteKeys
._cpc_DeleteKeys

	LD HL,tabla_teclas
	LD DE,tabla_teclas+1
	LD BC, 24
	LD (HL),$FF
	LDIR
	RET
