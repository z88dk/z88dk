
SECTION code_clib
SECTION code_l

PUBLIC l_lsl_dehldehl

INCLUDE "config_private.inc"

   ; logical shift left 64-bit number
   ;
   ; enter : dehl'dehl = 32-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl << a
   ;
   ; uses  : af, b, de, hl, de', hl'

   IF __CLIB_OPT_IMATH_SELECT & $04
   
      EXTERN l_fast_lsl_dehldehl
      
      defc l_lsl_dehldehl = l_fast_lsl_dehldehl
   
   ELSE
   
      EXTERN l_small_lsl_dehldehl
      
      defc l_lsl_dehldehl = l_small_lsl_dehldehl
   
   ENDIF
