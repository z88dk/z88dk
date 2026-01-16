
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_z180_muls_32_32x32

EXTERN l_z180_mulu_32_32x32, l_neg_dehl


l_z180_muls_32_32x32:

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

   call l_z180_mulu_32_32x32

   pop af
   ret P

   ; correct sign of result

   jp l_neg_dehl
