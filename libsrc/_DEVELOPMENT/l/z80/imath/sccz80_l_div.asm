
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_div
; 
; sccz80 division of two signed ints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

XLIB l_div

l_div:

   ; enter : hl = 16-bit divisor
   ;         de = 16-bit dividend
   ;
   ; exit  : hl = quotient
   ;         de = remainder
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_IMATH <= 50

   LIB l_small_divs_16_16x16
   
   ex de,hl
   jp l_small_divs_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   LIB l_fast_divs_16_16x16
   
   ex de,hl
   jp l_fast_divs_16_16x16

ENDIF
