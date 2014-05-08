
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_long_div
; 
; sccz80 signed division of two longs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_long_div

l_long_div:

   ; enter : dehl = 32-bit divisor
   ;         stack = 32-bit dividend, ret
   ;
   ; exit  : dehl = quotient
   ;         dehl'= remainder
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

IF __CLIB_OPT_IMATH <= 50

   exx
   
   pop af
   pop hl
   pop de
   push af
   
   exx
   
   EXTERN l_small_divs_32_32x32
   jp l_small_divs_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   exx
   
   pop af
   pop hl
   pop de
   push af

   exx
   
   EXTERN l_fast_divs_32_32x32
   jp l_fast_divs_32_32x32

ENDIF
