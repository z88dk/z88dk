;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;	cpc_GetScrAddress(int x, int y) __smallc ;
;
;       $Id: cpc_GetScrAddress.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetScrAddress
		
		EXTERN    cpc_GetScrAddress0


.cpc_GetScrAddress

; coordinates are in (A,L)

	pop	af
	pop	hl		; y
	pop bc		; x
	push bc
	push hl
	push af
	ld	a,c
	
	jp cpc_GetScrAddress0
