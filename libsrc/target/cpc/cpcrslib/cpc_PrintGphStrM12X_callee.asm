;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrM12X(char *, unsigned int address) __smallc ;
;
;       $Id: cpc_PrintGphStrM12X_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrM12X_callee
        PUBLIC    _cpc_PrintGphStrM12X_callee
		
        EXTERN    cpc_PrintGphStr0M1
		

.cpc_PrintGphStrM12X_callee
._cpc_PrintGphStrM12X_callee


	pop bc
	pop hl		; address
	pop de		; text
	push bc		; ret addr
	ld a,1
    
 JP cpc_PrintGphStr0M1
 
