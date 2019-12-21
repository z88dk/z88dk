;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStr(char *, unsigned int address) __smallc ;
;
;       $Id: cpc_PrintGphStr_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStr_callee
        PUBLIC    _cpc_PrintGphStr_callee
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0
		

.cpc_PrintGphStr_callee
._cpc_PrintGphStr_callee


	pop bc
	pop hl		; address
	pop de		; text
	push bc	; ret addr
	xor a
    
 JP cpc_PrintGphStr0
