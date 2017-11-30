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
;       $Id: cpc_PrintGphStrStd.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrStd
        PUBLIC    _cpc_PrintGphStrStd
		
        EXTERN    cpc_PrintGphStrStd0
		;EXTERN    color_uso


.cpc_PrintGphStrStd
._cpc_PrintGphStrStd

;preparación datos impresión. El ancho y alto son fijos!
	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)	;destino
	
	
   	ld e,(ix+2)
	ld d,(ix+3)	;texto origen

	ld a,(ix+4) ;color
	;ld (color_uso+1),a
	
 JP cpc_PrintGphStrStd0
