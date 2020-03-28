;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrM1(char *, unsigned int address) __smallc ;
;
;       $Id: cpc_PrintGphStrM1_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrM1_callee
        PUBLIC    _cpc_PrintGphStrM1_callee
		
        EXTERN    cpc_PrintGphStr0M1
		

.cpc_PrintGphStrM1_callee
._cpc_PrintGphStrM1_callee


	pop bc
	pop hl		; address
	pop de		; tesxt
	push bc	; ret addr
	xor a
    
 JP cpc_PrintGphStr0M1
 
