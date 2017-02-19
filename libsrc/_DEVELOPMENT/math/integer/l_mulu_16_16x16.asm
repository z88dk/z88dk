
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_16_16x16

   ; compute:  hl = hl * de
   ; alters :  af, bc, de, hl

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_16_16x16
   defc l_mulu_16_16x16 = l_small_mul_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_16_16x16
   defc l_mulu_16_16x16 = l_fast_mulu_16_16x16

ENDIF
