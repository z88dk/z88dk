;
;       Amstrad CPC library
;
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       void  cpc_RLI(unsigned int pos, unsigned char w, unsigned char h);
;
;       $Id: cpc_RLI.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_RLI
        PUBLIC    _cpc_RLI
		
        EXTERN    asm_cpc_RLI
		
.cpc_RLI
._cpc_RLI
		pop af
		pop de	; h
		pop bc	; w
		pop	hl	; pos
        push hl
		push bc
		push de
        push af
        jp asm_cpc_RLI
