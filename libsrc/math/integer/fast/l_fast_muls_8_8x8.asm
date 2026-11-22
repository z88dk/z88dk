
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_fast_muls_8_8x8

EXTERN l_fast_mulu_16_8x8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80

   EXTERN error_mulu_overflow_mc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

l_fast_muls_8_8x8:

   ; signed multiply of two 8-bit numbers
   ;
   ; error reported on overflow
   ;
   ; enter : l = 8-bit signed number
   ;         e = 8-bit signed number
   ;
   ; exit  : d = 0
   ;
   ;         success
   ;
   ;            hl = sign extended 8-bit product
   ;            carry reset
   ;
   ;         signed overflow (LIA-1 enabled only)
   ;
   ;            hl = sign extended CHAR_MIN or CHAR_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, b, de, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_IMATH_FAST & $80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
   ; determine sign of result
   
   ld a,l
   xor e
   push af
   
   ; make multiplicands positive
   
   bit 7,l
   jr z, ok_0
   
   xor a
   sub l
   ld l,a

ok_0:

   bit 7,e
   jr z, ok_1
   
   xor a
   sub e
   ld e,a

ok_1:

   ; mutliply and check for overflow
   
   call l_fast_mulu_16_8x8
   
   inc h
   dec h
   jr nz, unsigned_overflow
   
   bit 7,l
   jr nz, signed_overflow

   ; correct sign of result
   
   pop af
   ret p

   ld a,l   
   neg
   ld l,a
   dec h
   
   ret

unsigned_overflow:
signed_overflow:

   call error_mulu_overflow_mc
   
   ; hl = $ffff
   ; stack = sign of result
   
   pop af
   scf

   ld l,$80
   ret m                       ; return CHAR_MIN
   
   inc h
   dec l                       ; return CHAR_MAX
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   call l_fast_mulu_16_8x8
   
   ld a,l
   
   rla
   sbc a,a
   
   ld h,a                      ; sign extend L into H
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
