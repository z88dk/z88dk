
SECTION code_clib
SECTION code_l

PUBLIC l_lsr_dehl

INCLUDE "config_private.inc"

   ; logical shift right 32-bit unsigned long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl

   IF __CLIB_OPT_IMATH_SELECT & $02
   
      EXTERN l_fast_lsr_dehl
      
      defc l_lsr_dehl = l_fast_lsr_dehl
   
   ELSE
   
      EXTERN l_small_lsr_dehl
      
      defc l_lsr_dehl = l_small_lsr_dehl
   
   ENDIF
