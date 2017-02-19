
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_divu_64_64x8, l0_divu_64_64x8

   ; compute:  dehl'dehl = dehl'dehl / c, a = dehl'dehl % c
   ; alters :  af, bc, de, hl, de', hl'

   ; alternate entry (l0_divu_64_64x8)
   ; skips divide by zero check

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divu_64_64x8, l0_small_divu_64_64x8

   defc  l_divu_64_64x8 =  l_small_divu_64_64x8
   defc l0_divu_64_64x8 = l0_small_divu_64_64x8

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divu_64_64x8, l0_fast_divu_64_64x8
   
   defc  l_divu_64_64x8 =  l_fast_divu_64_64x8
   defc l0_divu_64_64x8 = l0_fast_divu_64_64x8

ENDIF
