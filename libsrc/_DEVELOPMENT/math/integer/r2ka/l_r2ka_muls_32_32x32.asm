; 2023 June feilipu

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

EXTERN l_r2ka_mulu_32_32x32

PUBLIC l_r2ka_muls_32_32x32

defc l_r2ka_muls_32_32x32 = l_r2ka_mulu_32_32x32

   ; signed multiplication of two 32-bit signed numbers
   ;
   ; error reported on overflow
   ;
   ; enter : dehl = signed 32-bit number
   ;         dehl'= signed 32-bit number
   ;
   ; exit  : success
   ;
   ;            dehl = signed 32-bit product
   ;            carry reset
   ;
   ;         signed overflow (LIA-1 enabled only)
   ;
   ;            dehl = LONG_MAX or LONG_MIN
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, bc. de, hl, bc', de', hl'
