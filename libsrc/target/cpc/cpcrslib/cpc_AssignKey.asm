;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_AssignKey.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_AssignKey
        PUBLIC    _cpc_AssignKey
		
        EXTERN    asm_cpc_AssignKey

.cpc_AssignKey
._cpc_AssignKey
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp asm_cpc_AssignKey
