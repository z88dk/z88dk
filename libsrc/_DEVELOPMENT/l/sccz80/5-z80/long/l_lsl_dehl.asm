
SECTION code_clib
SECTION code_l

PUBLIC l_lsl_dehl

INCLUDE "config_private.inc"

   ; logical shift left 32-bit number
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl << a
   ;
   ; uses  : af, b, de, hl

   IF __CLIB_OPT_IMATH_SELECT & $04
   
      EXTERN l_fast_lsl_dehl
      
      defc l_lsl_dehl = l_fast_lsl_dehl
   
   ELSE
   
      EXTERN l_small_lsl_dehl
      
      defc l_lsl_dehl = l_small_lsl_dehl
   
   ENDIF
