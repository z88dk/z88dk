;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXYM12X(char *, unsigned int address);
;
;       $Id: cpc_PrintGphStrXYM12X.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXYM12X
        PUBLIC    _cpc_PrintGphStrXYM12X
		
        EXTERN    cpc_PrintGphStr0M1
		EXTERN    cpc_GetScrAddress0


.cpc_PrintGphStrXYM12X
._cpc_PrintGphStrXYM12X

	ld ix,2
	add ix,sp
	

 	ld L,(ix+0)	;Y
	ld A,(ix+2)	;X
	
	call cpc_GetScrAddress0   ; hl= screen address

	;destino
	
   	ld e,(ix+4)
	ld d,(ix+5)	;texto origen
	ld	a,1

 JP cpc_PrintGphStr0M1
