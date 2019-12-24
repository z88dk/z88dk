;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStr2X(char *, unsigned int address);
;
;       $Id: cpc_PrintGphStr2X.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStr2X
        PUBLIC    _cpc_PrintGphStr2X
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0


.cpc_PrintGphStr2X
._cpc_PrintGphStr2X

	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)	;destino
	
   	ld e,(ix+2)
	ld d,(ix+3)	;texto origen
	ld a,1

    
 JP cpc_PrintGphStr0
