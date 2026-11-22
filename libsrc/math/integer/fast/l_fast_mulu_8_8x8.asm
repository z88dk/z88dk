
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_8_8x8

EXTERN l_fast_mulu_16_8x8

   ; unsigned multiplication of two 8-bit
   ; multiplicands into a sixteen bit product
   ;
   ; error reported on overflow
   ;
   ; enter : l = 8-bit multiplicand
   ;         e = 8-bit multiplicand
   ;
   ; exit  : a = 0
   ;         d = 0
   ;
   ;         success
   ;
   ;            h = 0 (LIA-1 enabled only)
   ;            l = 8-bit product
   ;            carry reset
   ;
   ;         unsigned overflow (LIA-1 enabled only)
   ;
   ;            h = $ff
   ;            l = $ff = UCHAR_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, b, de, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   EXTERN error_mulu_overflow_mc

l_fast_mulu_8_8x8:

   call l_fast_mulu_16_8x8
   
   inc h
   dec h
   ret z
   
   jp error_mulu_overflow_mc

ELSE

   defc l_fast_mulu_8_8x8 = l_fast_mulu_16_8x8

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
