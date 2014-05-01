
XLIB l_asr_dehl

INCLUDE "clib_cfg.asm"

l_asr_dehl:

   ; arithmetic shift right 32-bit signed long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, bc, de, hl

   IF __CLIB_OPT_IMATH_SELECT & $01
   
      LIB l_fast_asr_dehl
      jp l_fast_asr_dehl
   
   ELSE
   
      LIB l_small_asr_dehl
      jp l_small_asr_dehl
   
   ENDIF
