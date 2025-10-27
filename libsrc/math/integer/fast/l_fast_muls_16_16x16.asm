
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_muls_16_16x16

EXTERN l_fast_mulu_16_16x16, l_neg_de, l_neg_hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   EXTERN error_mulu_overflow_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


l_fast_muls_16_16x16:

   ; signed multiply of two 16-bit signed numbers
   ;
   ; error reported on overflow
   ;
   ; enter : de = 16-bit signed number
   ;         hl = 16-bit signed number
   ;
   ; exit  : success
   ;
   ;            hl = signed product
   ;            carry reset
   ;
   ;         signed overflow (LIA-1 enabled only)
   ;
   ;            hl = INT_MAX or INT_MIN
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, bc, de, hl

   ; determine sign of result

   ld a,d
   xor h
   push af
   
   ; make multiplicands positive
   
   bit 7,d
   call nz, l_neg_de
   
   bit 7,h
   call nz, l_neg_hl

   ; multiply & check for overflow
   
   call l_fast_mulu_16_16x16

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   jr c, unsigned_overflow

   bit 7,h
   jr nz, signed_overflow
   
   ; correct sign of result
   
   pop af
   ret p
   
   jp l_neg_hl

signed_overflow:

   call error_mulu_overflow_mc

unsigned_overflow:

   ; hl = $ffff
   ; stack = sign of result

   ld h,$7f                    ; hl = $7fff
   pop af
   
   scf                         ; indicate oveflow
   ret p                       ; if result is positive return INT_MAX
   
   inc hl                      ; return INT_MIN
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   pop af
   ret p
   
   ; correct sign of result
   
   jp l_neg_hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
