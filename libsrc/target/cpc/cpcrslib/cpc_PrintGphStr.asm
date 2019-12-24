;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_PrintGphStr(char *, unsigned int address);
;
;       $Id: cpc_PrintGphStr.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_PrintGphStr
        PUBLIC    _cpc_PrintGphStr
		
        EXTERN    cpc_GetScrAddress0
        EXTERN    cpc_PrintGphStr0


.cpc_PrintGphStr
._cpc_PrintGphStr

	ld ix,2
	add ix,sp
	
	ld l,(ix+0)
	ld h,(ix+1)	;destino
	
   	ld e,(ix+2)
	ld d,(ix+3)	;texto origen
	xor a

    
 JP cpc_PrintGphStr0
