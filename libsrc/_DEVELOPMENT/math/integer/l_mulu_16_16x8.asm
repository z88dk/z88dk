
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_16_16x8

   ; compute:  hl = hl * e
   ; alters :  af, bc, de, hl

IF __CPU_Z180__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z180_mulu_16_16x8
   defc l_mulu_16_16x8 = l_z180_mulu_16_16x8 - 1

ELSE

IF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z80n_mulu_16_16x8
   defc l_mulu_16_16x8 = l_z80n_mulu_16_16x8 - 1

ELSE

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_16_16x8
   defc l_mulu_16_16x8 = l_small_mul_16_16x8 - 1

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_24_16x8
   defc l_mulu_16_16x8 = l_fast_mulu_24_16x8

ENDIF

ENDIF

ENDIF
