
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_64_32x32

   ; multiplication of two 32-bit numbers into a 64-bit product
   ;
   ; enter : dehl = 32-bit multiplicand (more zeros = better performance)
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : dehl dehl' = 64-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_64_32x32
   
   defc l_mulu_64_32x32 = l_small_mul_64_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_64_32x32
   
   defc l_mulu_64_32x32 = l_fast_mulu_64_32x32

ENDIF
