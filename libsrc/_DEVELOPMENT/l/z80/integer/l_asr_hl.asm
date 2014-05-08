
PUBLIC l_asr_hl

INCLUDE "clib_cfg.asm"

l_asr_hl:

   ; arithmetic shift right 16-bit signed int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, bc, hl

   IF __CLIB_OPT_IMATH_SELECT & $01
   
      EXTERN l_fast_asr_hl
      jp l_fast_asr_hl
   
   ELSE
   
      EXTERN l_small_asr_hl
      jp l_small_asr_hl
   
   ENDIF
