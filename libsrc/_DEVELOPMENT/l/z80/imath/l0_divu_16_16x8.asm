
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l0_divu_16_16x8
; called by asm_utoa, asm_bit_play
;
; compute:  hl = hl / e, e = hl % e
; test for divide by zero unnecessary
; can alter: af, bc, de, hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l0_divu_16_16x8

l0_divu_16_16x8:

IF __CLIB_OPT_IMATH <= 50

   LIB l1_small_divu_16_16x16
   jp l1_small_divu_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   LIB l0_fast_divu_16_16x8
   jp l0_fast_divu_16_16x8

ENDIF
