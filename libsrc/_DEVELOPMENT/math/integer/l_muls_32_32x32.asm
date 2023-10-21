
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_muls_32_32x32

   ; compute:  dehl = dehl * dehl'
   ; alters :  af, bc, de, hl, bc', de', hl', ix

IF __CPU_KC160__

   EXTERN l_kc160_muls_32_32x32
   defc l_muls_32_32x32 = l_kc160_muls_32_32x32

ELIF (__CPU_Z180__ || __CPU_EZ80__) && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z180_muls_32_32x32
   defc l_muls_32_32x32 = l_z180_muls_32_32x32

ELIF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z80n_muls_32_32x32
   defc l_muls_32_32x32 = l_z80n_muls_32_32x32

ELIF ( __CPU_RABBIT__) && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_r2ka_muls_32_32x32
   defc l_muls_32_32x32 = l_r2ka_muls_32_32x32

ELIF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_muls_32_32x32
   defc l_muls_32_32x32 = l_small_muls_32_32x32

ELIF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_muls_32_32x32
   defc l_muls_32_32x32 = l_fast_muls_32_32x32

ENDIF
