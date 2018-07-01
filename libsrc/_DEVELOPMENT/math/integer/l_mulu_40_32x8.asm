
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_40_32x8

   ; compute:  adehl = dehl * a
   ; alters :  af, bc, de, hl, ixh
   ; z180 alters:   af, bc, de, hl, af'

IF __CPU_Z180__

   EXTERN l_z180_mulu_40_32x8
   defc l_mulu_40_32x8 = l_z180_mulu_40_32x8

ELSE

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_40_32x8

l_mulu_40_32x8:

   exx
   
   push bc
   push de
   push hl
   
   exx
   
   call l_small_mul_40_32x8
   
   exx
   
   pop hl
   pop de
   pop bc
   
   exx
   ret
   
ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_40_32x8
   defc l_mulu_40_32x8 = l_fast_mulu_40_32x8

ENDIF

ENDIF
