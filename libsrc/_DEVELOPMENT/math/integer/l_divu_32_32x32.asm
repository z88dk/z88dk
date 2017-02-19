
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_divu_32_32x32, l0_divu_32_32x32

   ; compute:  dehl = dehl' / dehl, dehl' = dehl' % dehl
   ; alters :  af, bc, de, hl, bc', de', hl', ix
   
   ; alternate entry (l_divu_32_32x32 - 1)
   ; exchanges divisor / dividend

   ; alternate entry (l0_divu_32_32x32)
   ; skips divide by zero check

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divu_32_32x32, l0_small_divu_32_32x32

   defc  l_divu_32_32x32 =  l_small_divu_32_32x32
   defc l0_divu_32_32x32 = l0_small_divu_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divu_32_32x32, l0_fast_divu_32_32x32
   
   defc  l_divu_32_32x32 =  l_fast_divu_32_32x32
   defc l0_divu_32_32x32 = l0_fast_divu_32_32x32

ENDIF
