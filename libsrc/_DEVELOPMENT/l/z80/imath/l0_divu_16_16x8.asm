
; l0_divu_16_16x8
; called by asm_utoa

; compute:  hl = hl / de, e = hl % de
; test for divide by zero unnecessary
; can alter: af, bc, de, hl

XLIB l0_divu_16_16x8

INCLUDE "clib_cfg.asm"

l0_divu_16_16x8:

;; IF __CLIB_OPT_MATH > 50

   LIB l0_fast_divu_16_16x8
   
   jp l0_fast_divu_16_16x8

;; ENDIF
