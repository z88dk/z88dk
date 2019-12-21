;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrStd(char *color, char *text);
;
;       $Id: cpc_PrintGphStrStd_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrStd_callee
        PUBLIC    _cpc_PrintGphStrStd_callee
		
        EXTERN    cpc_PrintGphStrStd0
		;EXTERN    color_uso
		

.cpc_PrintGphStrStd_callee
._cpc_PrintGphStrStd_callee


;preparación datos impresión. El ancho y alto son fijos!
	pop af
	pop hl		; screen address
	pop de		; text
	pop bc		; color
	push af		; ret addr
	ld	a,c
	
 JP cpc_PrintGphStrStd0
