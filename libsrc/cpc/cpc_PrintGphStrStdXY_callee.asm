;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrStdXY(int pen, char *, int x, int y) __smallc ;
;
;       $Id: cpc_PrintGphStrStdXY_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrStdXY_callee
        PUBLIC    _cpc_PrintGphStrStdXY_callee
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStrStd0
		EXTERN    color_uso
		

.cpc_PrintGphStrStdXY_callee
._cpc_PrintGphStrStdXY_callee


;preparación datos impresión. El ancho y alto son fijos!
	pop bc
	pop hl		; l=y
	pop de		; e=x
	ld	a,e
	ld (color_uso+1),a
	push bc	; ret addr
	
	call cpc_GetScrAddress0   ; hl= screen address
	pop bc	; ret addr
	pop de	; text
	push bc
    
 JP cpc_PrintGphStrStd0
