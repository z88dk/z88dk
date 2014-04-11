
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_16_16x16
; called by asm_heap_calloc, asm_bsearch, asm_qsort
;
; compute: hl = hl * de
; can alter: af, bc, de, hl
; carry set on overflow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_mulu_16_16x16

l_mulu_16_16x16:

;; IF __CLIB_OPT_IMATH > 50

   LIB l_fast_mulu_16_16x16
   
   jp l_fast_mulu_16_16x16

;; ENDIF
