
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l0_divu_32_32x8
; called by asm_ultoa
;
; compute:  dehl = dehl / c, a = dehl % c
; test for divide by zero unnecessary
; can alter: af, bc, de, hl, bc', de', hl'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l0_divu_32_32x8

l0_divu_32_32x8:

;; IF __CLIB_OPT_IMATH > 50

   LIB l0_fast_divu_32_32x8
   jp l0_fast_divu_32_32x8

;; ENDIF
