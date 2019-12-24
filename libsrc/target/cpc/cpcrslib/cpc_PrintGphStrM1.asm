;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStrM1(char *, unsigned int address);
;
;       $Id: cpc_PrintGphStrM1.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStrM1
        PUBLIC    _cpc_PrintGphStrM1
		
        EXTERN    cpc_PrintGphStr0M1


.cpc_PrintGphStrM1
._cpc_PrintGphStrM1

	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)	;destino
	
   	ld e,(ix+2)
	ld d,(ix+3)	;texto origen
	xor a

    
 JP cpc_PrintGphStr0M1
