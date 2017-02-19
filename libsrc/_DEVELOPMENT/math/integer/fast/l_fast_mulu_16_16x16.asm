
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_16_16x16

EXTERN l_fast_mulu_24_16x8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   EXTERN error_mulu_overflow_mc

ELSE

   EXTERN l_fast_mulu_32_24x16
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_fast_mulu_16_16x16:

   ; unsigned multiplication of two 16-bit
   ; multiplicands into a 16-bit product
   ;
   ; error reported on overflow
   ;
   ; enter : de = 16-bit multiplicand
   ;         hl = 16-bit multiplicand
   ;
   ; exit  : success
   ;
   ;             a = 0 (LIA-1 enabled only)
   ;            hl = 16-bit product
   ;            carry reset
   ;
   ;         unsigned overflow (LIA-1 enabled only)
   ;
   ;            hl = $ffff = UINT_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, bc, de, hl

   ; try to reduce the multiplication

   inc d
   dec d

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   jr z, reduce_0

ELSE

   jp z, l_fast_mulu_24_16x8

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   inc h
   dec h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   jp nz, error_mulu_overflow_mc  ; if both de and hl > 255

ELSE

   jr nz, mulu_32_16x16

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ex de,hl
   
reduce_0:

   ;  e = 8-bit multiplicand
   ; hl = 16-bit multiplicand

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   call l_fast_mulu_24_16x8
   
   or a
   ret z                       ; if result confined to hl

   jp error_mulu_overflow_mc

ELSE

   jp l_fast_mulu_24_16x8

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF (__CLIB_OPT_IMATH_FAST & $80) = 0

mulu_32_16x16:

   ld c,e
   ld b,d
   ld e,0

   IF __CLIB_OPT_IMATH_FAST & $04

      jp l_fast_mulu_32_24x16

   ELSE

      push ix
     
      call l_fast_mulu_32_24x16
     
      pop ix
      ret

   ENDIF

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
