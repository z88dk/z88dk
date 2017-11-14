;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrXYM1(char *, unsigned int address);
;
;       $Id: cpc_PrintGphStrXYM1.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrXYM1
        PUBLIC    _cpc_PrintGphStrXYM1
		
        EXTERN    cpc_PrintGphStr0M1
		EXTERN    cpc_GetScrAddress0


.cpc_PrintGphStrXYM1
._cpc_PrintGphStrXYM1

	ld ix,2
	add ix,sp
	

 	ld L,(ix+0)	;Y
	ld A,(ix+2)	;X
	
	call cpc_GetScrAddress0   ; hl= screen address

	;destino
	
   	ld e,(ix+4)
	ld d,(ix+5)	;texto origen
	xor a

 JP cpc_PrintGphStr0M1
