
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mulint_rrx_s
; 
; sdcc multiplication of two ints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NOTE: sdcc does not distinguish
; between signed and unsigned multiply
; so the LIA-1 option will not generate
; correct results.

INCLUDE "clib_cfg.asm"

PUBLIC __mulint_rrx_s

__mulint_rrx_s:

   ; enter : stack = multiplicand, multiplicand, ret
   ;
   ; exit  : hl = product
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_IMATH <= 50

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   EXTERN l_small_mul_16_16x16
   jp l_small_mul_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   EXTERN l_fast_mulu_16_16x16
   jp l_fast_mulu_16_16x16     ; hl = hl * de

ENDIF
