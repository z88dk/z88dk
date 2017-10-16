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
        EXTERN     cpc_SetColour_callee
        EXTERN    ASMDISP_CPC_SETCOLOUR_CALLEE

.cpc_SetColour
._cpc_SetColour
        pop     bc
        pop     hl
        pop     de
        push    de
        push    hl
        push    bc
        jp cpc_SetColour_callee + ASMDISP_CPC_SETCOLOUR_CALLEE
