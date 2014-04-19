
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_32_16x16
; called by asm_bit_beep
;
; compute: dehl = hl * de
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_mulu_32_16x16

l_mulu_32_16x16:

;; IF __CLIB_OPT_IMATH > 50

   LIB l_fast_mulu_32_16x16
   jp l_fast_mulu_32_16x16

;; ENDIF
