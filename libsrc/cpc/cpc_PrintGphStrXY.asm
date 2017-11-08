;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXY(char *, int x, int y);
;
;       $Id: cpc_PrintGphStrXY.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXY
        PUBLIC    _cpc_PrintGphStrXY
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0


.cpc_PrintGphStrXY
._cpc_PrintGphStrXY


;preparación datos impresión. El ancho y alto son fijos!
	ld ix,2
	add ix,sp
	

 	ld L,(ix+0)	;Y
	ld A,(ix+2)	;X
	
	call cpc_GetScrAddress0   ; hl= screen address

	;destino
	
   	ld e,(ix+4)
	ld d,(ix+5)	;texto origen
	xor a
	
    
 JP cpc_PrintGphStr0
 
