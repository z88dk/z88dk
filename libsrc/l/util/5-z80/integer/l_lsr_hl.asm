
SECTION code_clib
SECTION code_l

PUBLIC l_lsr_hl

INCLUDE "config_private.inc"

   ; logical shift right 16-bit unsigned int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, b, hl

   IF __CLIB_OPT_IMATH_SELECT & $02
   
      EXTERN l_fast_lsr_hl
      
      defc l_lsr_hl = l_fast_lsr_hl
   
   ELSE
   
      EXTERN l_small_lsr_hl
      
      defc l_lsr_hl = l_small_lsr_hl
   
   ENDIF
