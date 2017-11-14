;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXYM12X(char *, unsigned int address) __smallc ;
;
;       $Id: cpc_PrintGphStrXYM12X_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXYM12X_callee
        PUBLIC    _cpc_PrintGphStrXYM12X_callee
		
        EXTERN    cpc_PrintGphStr0M1
		EXTERN    cpc_GetScrAddress0


.cpc_PrintGphStrXYM12X_callee
._cpc_PrintGphStrXYM12X_callee

;preparación datos impresión. El ancho y alto son fijos!
	pop bc
	pop hl		; l=y
	pop de		; e=x
	ld	a,e
	push bc	; ret addr
	
	call cpc_GetScrAddress0   ; hl= screen address
	pop bc	; ret addr
	pop de	; text
	push bc
	ld	a,1
    
 JP cpc_PrintGphStr0M1
