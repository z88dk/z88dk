
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_16_16x16
; called by asm_heap_calloc, asm_bsearch, asm_qsort
;
; compute: hl = hl * de
; can alter: af, bc, de, hl
; carry set on overflow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_mulu_16_16x16

l_mulu_16_16x16:

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_16_16x16
   jp l_small_mul_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_16_16x16
   jp l_fast_mulu_16_16x16

ENDIF
