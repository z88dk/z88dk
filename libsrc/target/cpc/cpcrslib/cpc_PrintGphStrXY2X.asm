;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXY2X(char *, int x, int y);
;
;       $Id: cpc_PrintGphStrXY2X.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXY2X
        PUBLIC    _cpc_PrintGphStrXY2X
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0


.cpc_PrintGphStrXY2X
._cpc_PrintGphStrXY2X


;preparación datos impresión. El ancho y alto son fijos!
	ld ix,2
	add ix,sp
	

 	ld L,(ix+0)	;Y
	ld A,(ix+2)	;X
	
	call cpc_GetScrAddress0   ; hl= screen address

	;destino
	
   	ld e,(ix+4)
	ld d,(ix+5)	;texto origen
	ld	a,1
	
    
 JP cpc_PrintGphStr0
 
