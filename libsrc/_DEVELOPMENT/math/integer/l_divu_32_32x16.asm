
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_divu_32_32x16, l0_divu_32_32x16

   ; compute:  dehl = dehl / bc, dehl' = dehl % bc
   ; alters :  af, bc, de, hl, bc', de', hl', ix

   ; alternate entry (l0_divu_32_32x16)
   ; skips divide by zero check

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divu_32_32x32, l0_small_divu_32_32x32

l_divu_32_32x16:

   scf

l0_divu_32_32x16:

   push bc
   
   exx
   
   pop hl
   ld de,0
   
   jp nc, l0_small_divu_32_32x32
   jp l_small_divu_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divu_32_32x16, l0_fast_divu_32_32x16
   
   defc  l_divu_32_32x16 =  l_fast_divu_32_32x16
   defc l0_divu_32_32x16 = l0_fast_divu_32_32x16

ENDIF
