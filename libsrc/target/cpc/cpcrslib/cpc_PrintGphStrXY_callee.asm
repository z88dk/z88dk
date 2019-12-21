;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXY(char *, int x, int y) __smallc ;
;
;       $Id: cpc_PrintGphStrXY_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXY_callee
        PUBLIC    _cpc_PrintGphStrXY_callee
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0
		

.cpc_PrintGphStrXY_callee
._cpc_PrintGphStrXY_callee


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
    
 JP cpc_PrintGphStr0
 
