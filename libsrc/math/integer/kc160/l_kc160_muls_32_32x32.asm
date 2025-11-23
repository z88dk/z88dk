
SECTION code_clib
SECTION code_math

PUBLIC l_kc160_muls_32_32x32

EXTERN l_kc160_mulu_32_32x32
EXTERN l_neg_dehl

   ; multiplication of two 32-bit numbers into a 64-bit product
   ;
   ; enter : dehl = 32-bit multiplicand (more zeros = better performance)
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : dehl = 64-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

l_kc160_muls_32_32x32:
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
   call NZ,l_neg_dehl

   exx

   bit 7,d
   call NZ,l_neg_dehl

   ; multiply & check for overflow

   call l_kc160_mulu_32_32x32

   pop af
   ret P

   ; correct sign of result

   jp l_neg_dehl
