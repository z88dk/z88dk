
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_mulu_16_8x8
; called by asm_bit_play
;
; compute: hl = l * e
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_mulu_16_8x8

l_mulu_16_8x8:

IF __CLIB_OPT_IMATH <= 50

   LIB l0_small_mul_16_16x16
   
   ld h,0
   ld d,h
   jp l0_small_mul_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   LIB l_fast_mulu_16_8x8
   jp l_fast_mulu_16_8x8

ENDIF
