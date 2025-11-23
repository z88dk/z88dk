
SECTION code_clib
SECTION code_l

PUBLIC l_lsr_dehldehl

INCLUDE "config_private.inc"

   ; logical shift right 64-bit unsigned long
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl >> a
   ;
   ; uses  : af, b, de, hl, de', hl'

   IF __CLIB_OPT_IMATH_SELECT & $02
   
      EXTERN l_fast_lsr_dehldehl
      
      defc l_lsr_dehldehl = l_fast_lsr_dehldehl
   
   ELSE
   
      EXTERN l_small_lsr_dehldehl
      
      defc l_lsr_dehldehl = l_small_lsr_dehldehl
   
   ENDIF
