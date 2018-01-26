;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_PrintStr.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintStr
        PUBLIC    _cpc_PrintStr
        
        EXTERN firmware

        INCLUDE "target/cpc/def/cpcfirm.def"              


.cpc_PrintStr
._cpc_PrintStr


.bucle_imp_cadena
	ld a,(hl)	
	or a ;		cp 0
	jr z,salir_bucle_imp_cadena
	call firmware
	defw txt_output
	inc hl
	jr bucle_imp_cadena
.salir_bucle_imp_cadena
	ld a,$0d	; para terminar hace un salto de línea
	call firmware
	defw txt_output
	ld a,$0a
	call firmware
	defw txt_output
	ret

