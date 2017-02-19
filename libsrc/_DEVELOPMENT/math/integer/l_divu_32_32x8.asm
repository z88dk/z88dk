
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_divu_32_32x8, l0_divu_32_32x8

   ; compute:  dehl = dehl / c, a = dehl % c
   ; alters :  af, bc, de, hl, bc', de', hl'

   ; alternate entry (l0_divu_32_32x8)
   ; skips divide by zero check

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_divu_32_32x32, l0_small_divu_32_32x32

l_divu_32_32x8:

   scf

l0_divu_32_32x8:

   ld a,c
   
   exx
   
   ld l,a
   ld de,0
   ld h,d
   
   call nc, l0_small_divu_32_32x32
   call c, l_small_divu_32_32x32
   
   exx
   ld a,l
   exx
   
   ret

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_divu_32_32x8, l0_fast_divu_32_32x8
   
   defc  l_divu_32_32x8 =  l_fast_divu_32_32x8
   defc l0_divu_32_32x8 = l0_fast_divu_32_32x8

ENDIF
