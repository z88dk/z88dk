;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrM12X(char *, unsigned int address);
;
;       $Id: cpc_PrintGphStrM12X.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrM12X
        PUBLIC    _cpc_PrintGphStrM12X
		
        EXTERN    cpc_PrintGphStr0M1


.cpc_PrintGphStrM12X
._cpc_PrintGphStrM12X

	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)	;destino
	
   	ld e,(ix+2)
	ld d,(ix+3)	;texto origen
	ld a,1

    
 JP cpc_PrintGphStr0M1
 
