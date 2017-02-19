
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_divs_16_16x16, l0_divs_16_16x16

   ; compute:  hl = hl / de, de = hl % de
   ; alters :  af, bc, de, hl
   
   ; alternate entry (l_divs_16_16x16 - 1)
   ; exchanges de,hl
   
   ; alternate entry (l0_divs_16_16x16)
   ; skips divide by zero check
   

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divs_16_16x16, l0_small_divs_16_16x16
   
   defc  l_divs_16_16x16 = l_small_divs_16_16x16
   defc l0_divs_16_16x16 = l0_small_divs_16_16x16

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divs_16_16x16, l0_fast_divs_16_16x16
   
   defc  l_divs_16_16x16 = l_fast_divs_16_16x16
   defc l0_divs_16_16x16 = l0_fast_divs_16_16x16

ENDIF
