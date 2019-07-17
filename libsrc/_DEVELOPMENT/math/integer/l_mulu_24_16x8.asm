
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_24_16x8

   ; compute:  ahl = hl * e
   ; alters :  af, bc, de, hl

IF __CPU_Z180__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z180_mulu_24_16x8
   defc l_mulu_24_16x8 = l_z180_mulu_24_16x8

ELSE

IF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z80n_mulu_24_16x8
   defc l_mulu_24_16x8 = l_z80n_mulu_24_16x8

ELSE

IF __CLIB_OPT_IMATH <= 50

   EXTERN l0_small_mul_32_32x32
   
l_mulu_24_16x8:

   ld c,e
   ex de,hl
   
   xor a
   ld l,a
   ld h,a
   ld b,a
   
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
   
   ld a,e
   ret

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_24_16x8
   defc l_mulu_24_16x8 = l_fast_mulu_24_16x8

ENDIF

ENDIF

ENDIF
