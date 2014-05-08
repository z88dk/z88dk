
PUBLIC l_lsl_hl

INCLUDE "clib_cfg.asm"

l_lsl_hl:

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
      jp l_fast_lsl_hl
   
   ELSE
   
      EXTERN l_small_lsl_hl
      jp l_small_lsl_hl
   
   ENDIF
