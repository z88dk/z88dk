;
;       Amstrad CPC library
;       (CALLER linkage for function pointers)
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;
;       $Id: cpc_SpUpdX.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_SpUpdX
        PUBLIC    _cpc_SpUpdX
		
        EXTERN     cpc_SpUpdX_callee
        EXTERN    ASMDISP_CPC_SPUPDX_CALLEE

.cpc_SpUpdX
._cpc_SpUpdX
   pop bc
   pop de
   pop ix
   push de	; ..saving a little more
   push de
   push bc
   jp cpc_SpUpdX_callee + ASMDISP_CPC_SPUPDX_CALLEE
