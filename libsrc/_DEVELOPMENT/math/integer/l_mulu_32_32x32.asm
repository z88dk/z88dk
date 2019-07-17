
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_mulu_32_32x32

   ; compute:  dehl = dehl * dehl'
   ; alters :  af, bc, de, hl, bc', de', hl', ix

IF __CPU_Z180__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z180_mulu_32_32x32
   defc l_mulu_32_32x32 = l_z180_mulu_32_32x32

ELSE

IF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z80n_mulu_32_32x32
   defc l_mulu_32_32x32 = l_z80n_mulu_32_32x32

ELSE

IF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_32_32x32
   defc l_mulu_32_32x32 = l_small_mul_32_32x32

ENDIF

IF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_32_32x32
   defc l_mulu_32_32x32 = l_fast_mulu_32_32x32

ENDIF

ENDIF

ENDIF
