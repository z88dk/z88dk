
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l0_divu_16_16x16
; called by asm_qsort
;
; compute:  hl = hl / de, de = hl % de
; test for divide by zero unnecessary
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l0_divu_16_16x16

l0_divu_16_16x16:

IF __CLIB_OPT_IMATH <= 50

   EXTERN l0_small_divu_16_16x16
   jp l0_small_divu_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l0_fast_divu_16_16x16
   jp l0_fast_divu_16_16x16

ENDIF
