
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; l_div_u
; 
; sccz80 division of two unsigned ints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "clib_cfg.asm"

PUBLIC l_div_u

l_div_u:

   ; enter : hl = 16-bit divisor
   ;         de = 16-bit dividend
   ;
   ; exit  : hl = quotient
   ;         de = remainder
   ;
   ; uses  : af, bc, de, hl

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divu_16_16x16
   
   ex de,hl
   jp l_small_divu_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divu_16_16x16
   
   ex de,hl
   jp l_fast_divu_16_16x16

ENDIF
