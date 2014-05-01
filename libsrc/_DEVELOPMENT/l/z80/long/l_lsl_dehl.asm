
XLIB l_lsl_dehl

INCLUDE "clib_cfg.asm"

l_lsl_dehl:

   ; logical shift left 32-bit number
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl << a
   ;
   ; uses  : af, b, de, hl

   IF __CLIB_OPT_IMATH_SELECT & $04
   
      LIB l_fast_lsl_dehl
      jp l_fast_lsl_dehl
   
   ELSE
   
      LIB l_small_lsl_dehl
      jp l_small_lsl_dehl
   
   ENDIF
