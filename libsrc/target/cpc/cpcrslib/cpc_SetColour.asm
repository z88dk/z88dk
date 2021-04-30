;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       set color
;
;       void __LIB__ cpc_cpc_SetColour(int pos, int color);
;
;       $Id: cpc_SetColour.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SetColour
        PUBLIC    _cpc_SetColour
        EXTERN     asm_cpc_SetColour

.cpc_SetColour
._cpc_SetColour
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp asm_cpc_SetColour
