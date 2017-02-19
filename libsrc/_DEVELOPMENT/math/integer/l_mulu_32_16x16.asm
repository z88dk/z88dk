
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_32_16x16

   ; compute:  dehl = hl * de
   ; alters :  af, bc, de, hl

IF __CLIB_OPT_IMATH <= 50

   EXTERN l0_small_mul_32_32x32
   
l_mulu_32_16x16:

   ld c,l
   ld b,h
   
   xor a
   ld l,a
   ld h,a
   
   exx
      
   push bc
   push de
   push hl
   
   ld l,a
   ld h,a
   ld c,a
   ld b,a
   ld e,a
   ld d,a
   
   call l0_small_mul_32_32x32
   
   exx
   
   pop hl
   pop de
   pop bc
   
   exx
   ret

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_32_16x16
   defc l_mulu_32_16x16 = l_fast_mulu_32_16x16

ENDIF
