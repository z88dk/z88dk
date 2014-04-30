
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mullong_rrx_s
; 
; sdcc multiplication of two longs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NOTE: sdcc does not distinguish
; between signed and unsigned multiply
; so the LIA-1 option will not generate
; correct results.

INCLUDE "clib_cfg.asm"

XLIB __mullong_rrx_s

__mullong_rrx_s:

   ; enter : stack = 32-bit multiplicand, 32-bit multiplicand, ret
   ;
   ; exit  : dehl = product
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', (iy if SDCC_IY)

IF __CLIB_OPT_IMATH <= 50

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push de
   push hl
   push af
   
   LIB l_small_mul_32_32x32
   jp l_small_mul_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   pop af
   pop hl
   pop de
   exx
   pop hl
   pop de
   
   push de
   push hl
   exx
   push de
   push hl
   push af

   IF __SDCC_IX

      push ix

      LIB l_fast_mulu_32_32x32
      call l_fast_mulu_32_32x32

      pop ix
      ret
   
   ELSE
   
      LIB l_fast_mulu_32_32x32
      jp l_fast_mulu_32_32x32
   
   ENDIF
   
ENDIF
