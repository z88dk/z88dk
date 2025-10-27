
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_muls_64_64x64

   ; 64-bit multiplication
   ;
   ; enter :      +-------------------------------
   ;              | +15 
   ;              | ...  multiplicand AB (8 bytes)
   ;              | + 8 
   ;         ix = |-------------------------------
   ;              | + 7
   ;              | ...  multiplicand CD (8 bytes)
   ;              | + 0
   ;              +-------------------------------
   ;
   ; exit  : ix structure unchanged
   ;         dehl' dehl = 64-bit product
   ;         carry set if overflow
   ;
   ; uses  : af, bc, de, hl, af', bc', de', hl'

IF (__CPU_Z180__ || __CPU_EZ80__) && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z180_mulu_64_64x64
   defc l_muls_64_64x64 = l_z180_mulu_64_64x64

ELIF __CPU_Z80N__ && ((__CLIB_OPT_IMATH = 0) || (__CLIB_OPT_IMATH = 100))

   EXTERN l_z80n_mulu_64_64x64
   defc l_muls_64_64x64 = l_z80n_mulu_64_64x64

ELIF __CLIB_OPT_IMATH <= 50

   EXTERN l_small_mul_64_64x64
   defc l_muls_64_64x64 = l_small_mul_64_64x64

ELIF __CLIB_OPT_IMATH > 50

   EXTERN l_fast_mulu_64_64x64
   defc l_muls_64_64x64 = l_fast_mulu_64_64x64

ENDIF

