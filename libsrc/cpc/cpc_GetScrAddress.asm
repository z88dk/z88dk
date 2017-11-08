;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;	cpc_GetScrAddress(char *x, char *y) __smallc ;
;
;       $Id: cpc_GetScrAddress.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetScrAddress
		
		EXTERN    cpc_GetScrAddress0


.cpc_GetScrAddress
	ld hl,2	;10
    add hl,sp	;11		
    
	ld e,(hl)	;7
	inc hl		;6
	inc hl		;6
	ld a,(hl)	;7
	;ex de,hl	;4
	ld l,e		;4
	;51
	jp cpc_GetScrAddress0
