;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_SpUpdY.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SpUpdY
        PUBLIC    _cpc_SpUpdY
		
        EXTERN     cpc_SpUpdY_callee
        EXTERN    ASMDISP_CPC_SPUPDY_CALLEE

.cpc_SpUpdY
._cpc_SpUpdY
   pop bc
   pop de
   pop ix
   push de	; ..saving a little more
   push de
   push bc
   jp cpc_SpUpdY_callee + ASMDISP_CPC_SPUPDY_CALLEE
