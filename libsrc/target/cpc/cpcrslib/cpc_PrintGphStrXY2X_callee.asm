;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXY2X(char *, int x, int y) __smallc ;
;
;       $Id: cpc_PrintGphStrXY2X_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXY2X_callee
        PUBLIC    _cpc_PrintGphStrXY2X_callee
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0
		

.cpc_PrintGphStrXY2X_callee
._cpc_PrintGphStrXY2X_callee


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
    
 JP cpc_PrintGphStr0
 
