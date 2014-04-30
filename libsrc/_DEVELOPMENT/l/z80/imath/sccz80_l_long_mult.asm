
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_long_mult
; 
; sccz80 multiplication of two longs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NOTE: this entry does not distinguish
; between signed and unsigned multiply
; so the LIA-1 option will not generate
; correct results.

INCLUDE "clib_cfg.asm"

XLIB l_long_mult

l_long_mult:

   ; enter : dehl = 32-bit multiplicand
   ;         stack = 32-bit multiplicand, ret
   ;
   ; exit  : dehl = product
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

IF __CLIB_OPT_IMATH <= 50

   exx
   
   pop af
   pop hl
   pop de
   push af
   
   LIB l_small_mul_32_32x32
   jp l_small_mul_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   exx
   
   pop af
   pop hl
   pop de
   push af

   LIB l_fast_mulu_32_32x32
   jp l_fast_mulu_32_32x32     ; dehl = product

ENDIF
