
SECTION code_clib
SECTION code_l

PUBLIC l_asr_dehldehl

INCLUDE "config_private.inc"

   ; arithmetic shift right 64-bit signed long
   ;
   ; enter : dehl'dehl = 32-bit number
   ;                  a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl >> a
   ;
   ; uses  : af, b, de, hl, de', hl'

   IF __CLIB_OPT_IMATH_SELECT & $01
   
      EXTERN l_fast_asr_dehldehl
      
      defc l_asr_dehldehl = l_fast_asr_dehldehl
   
   ELSE
   
      EXTERN l_small_asr_dehldehl
      
      defc l_asr_dehldehl = l_small_asr_dehldehl
   
   ENDIF
