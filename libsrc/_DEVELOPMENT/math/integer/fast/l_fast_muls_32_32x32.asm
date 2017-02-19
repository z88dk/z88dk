
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_muls_32_32x32

EXTERN l_fast_mulu_32_32x32, l_neg_dehl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   EXTERN error_mulu_overflow_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_fast_muls_32_32x32:

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

   ; determine sign of result
   
   ld a,d
   exx
   xor d
   
   push af
   
   ; make multiplicands positive
   
   bit 7,d
   call nz, l_neg_dehl

   exx
   
   bit 7,d
   call nz, l_neg_dehl
   
   ; multiply & check for overflow
   
   call l_fast_mulu_32_32x32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jr c, unsigned_overflow
   
   bit 7,d
   jr nz, signed_overflow

   ; correct sign of result
   
   pop af
   ret p
   
   jp l_neg_dehl

signed_overflow:

   call error_mulu_overflow_mc
   
   ld e,l
   ld d,h

unsigned_overflow:

   ; dehl = $ffffffff
   ; stack = sign of result

   ld d,$7f                    ; dehl = LONG_MAX
   pop af
   
   scf
   ret p                       ; if result is positive
   
   inc de
   inc hl                      ; dehl = LONG_MIN
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop af
   ret p
   
   ; correct sign of result
   
   jp l_neg_dehl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
