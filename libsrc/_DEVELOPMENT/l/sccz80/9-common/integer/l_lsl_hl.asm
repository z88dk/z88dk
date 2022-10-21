
SECTION code_clib
SECTION code_l

PUBLIC l_lsl_hl

INCLUDE "config_private.inc"

   ; logical shift left 16-bit number
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl << a
   ;
   ; uses  : af, b, hl

   IF __CLIB_OPT_IMATH_SELECT & $04
   
      EXTERN l_fast_lsl_hl
      
      defc l_lsl_hl = l_fast_lsl_hl
   
   ELSE
   
      EXTERN l_small_lsl_hl
      
      defc l_lsl_hl = l_small_lsl_hl
   
   ENDIF
