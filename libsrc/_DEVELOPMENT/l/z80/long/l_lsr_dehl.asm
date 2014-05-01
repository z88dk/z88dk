
XLIB l_lsr_dehl

INCLUDE "clib_cfg.asm"

l_lsr_dehl:

   ; logical shift right 32-bit unsigned long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl

   IF __CLIB_OPT_IMATH_SELECT & $02
   
      LIB l_fast_lsr_dehl
      jp l_fast_lsr_dehl
   
   ELSE
   
      LIB l_small_lsr_dehl
      jp l_small_lsr_dehl
   
   ENDIF
