;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;	cpc_GetScrAddress(char *x, char *y) __smallc ;
;
;       $Id: cpc_GetScrAddress_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetScrAddress_callee
		
		EXTERN    cpc_GetScrAddress0


.cpc_GetScrAddress_callee

; coordinates are in (L,A)

	pop af
	pop	bc	; x
	pop hl	; y
	push af	; ret addr
	ld	a,c
	
	jp cpc_GetScrAddress0
