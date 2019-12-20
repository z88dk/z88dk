;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrStdXY(int pen, char *, int x, int y);
;
;       $Id: cpc_PrintGphStrStdXY.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrStdXY
        PUBLIC    _cpc_PrintGphStrStdXY
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStrStd0
		;EXTERN    color_uso


.cpc_PrintGphStrStdXY
._cpc_PrintGphStrStdXY


;preparación datos impresión. El ancho y alto son fijos!
	ld ix,2
	add ix,sp
	

 	ld L,(ix+0)	;Y
	ld A,(ix+2)	;X
	
	call cpc_GetScrAddress0   ; hl= screen address

	;destino
	
   	ld e,(ix+4)
	ld d,(ix+5)	;texto origen
	
	ld a,(ix+6) ;color
	;ld (color_uso+1),a
    
 JP cpc_PrintGphStrStd0
