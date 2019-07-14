
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_72_64x8

   ; multiplication of a 64-bit number and an 8-bit number into 72-bit result
   ;
   ; enter :   dehl'dehl = 64-bit multiplicand
   ;                   a = 8-bit multiplicand
   ;
   ; exit  : a dehl'dehl = 72-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

IF __CPU_Z180__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z180_mulu_72_64x8
   defc l_mulu_72_64x8 = l_z180_mulu_72_64x8

ELSE

IF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z80n_mulu_72_64x8
   defc l_mulu_72_64x8 = l_z80n_mulu_72_64x8

ELSE

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_72_64x8
   defc l_mulu_72_64x8 = l_small_mul_72_64x8

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_72_64x8
   defc l_mulu_72_64x8 = l_fast_mulu_72_64x8

ENDIF

ENDIF

ENDIF
