;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_RRI(unsigned int pos, unsigned char w, unsigned char h);
;
;       $Id: cpc_RRI.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_RRI
        PUBLIC    _cpc_RRI
		
        EXTERN    asm_cpc_RRI
		
.cpc_RRI
._cpc_RRI
		pop af
		pop de	; h
		pop bc	; w
		pop	hl	; pos
        push hl
		push bc
		push de
        push af
        jp asm_cpc_RRI
