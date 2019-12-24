;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXYM1(char *, unsigned int address) __smallc ;
;
;       $Id: cpc_PrintGphStrXYM1_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXYM1_callee
        PUBLIC    _cpc_PrintGphStrXYM1_callee
		
        EXTERN    cpc_PrintGphStr0M1
		EXTERN    cpc_GetScrAddress0


.cpc_PrintGphStrXYM1_callee
._cpc_PrintGphStrXYM1_callee

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
	xor a
    
 JP cpc_PrintGphStr0M1
