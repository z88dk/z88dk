
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_16_16x8
; called by asm_bit_play
;
; compute: hl = hl * e
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_mulu_16_16x8

l_mulu_16_16x8:

;; IF __CLIB_OPT_IMATH > 50

   LIB l_fast_mulu_24_16x8
   jp l_fast_mulu_24_16x8

;; ENDIF
