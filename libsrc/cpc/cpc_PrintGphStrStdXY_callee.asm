;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrStdXY(int *string, char *x, char *y);
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
	pop hl		; l
	pop de
	ld	a,e		;palette
	push bc	; ret addr

 	ld L,(ix+0)	;Y
	ld A,(ix+2)	;X
	
	call cpc_GetScrAddress0   ; hl= screen address
	pop hl	; ret addr
	pop de	; text
	ex (sp),hl
	ld	a,l	; color

	ld (color_uso+1),a
    
 JP cpc_PrintGphStrStd0
 
