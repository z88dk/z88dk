;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;	cpc_GetScrAddress(int x, int y) __smallc ;
;
;       $Id: cpc_GetScrAddress_callee.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetScrAddress_callee
		
		EXTERN    cpc_GetScrAddress0


.cpc_GetScrAddress_callee

; coordinates are in (A,L)

	
	pop hl
	pop	bc		; y
	ex (sp),hl	; x
	ld	a,l
	ld	l,c
	
	jp cpc_GetScrAddress0
