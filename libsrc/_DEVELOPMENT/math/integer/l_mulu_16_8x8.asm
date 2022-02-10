
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_16_8x8

   ; compute:  hl = l * e
   ; alters :  af, bc, de, hl

IF __CPU_Z180__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

l_mulu_16_8x8:

   ld h,e
   mlt hl
   ret

ELSE

IF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

l_mulu_16_8x8:

   ld d,l
   mul de
   ex de,hl
   ret

ELSE

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_16_16x8

l_mulu_16_8x8:

   ld d,0
   jp l_small_mul_16_16x8

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_16_8x8
   defc l_mulu_16_8x8 = l_fast_mulu_16_8x8

ENDIF

ENDIF

ENDIF
