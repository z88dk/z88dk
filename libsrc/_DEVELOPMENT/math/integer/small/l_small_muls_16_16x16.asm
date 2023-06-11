
INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_small_muls_16_16x16

EXTERN l_small_mul_16_16x16, l_neg_de, l_neg_hl


l_small_muls_16_16x16:

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
   ; uses  : af, bc, de, hl

   ; determine sign of result

   ld a,d
   xor h
   push af

   ; make multiplicands positive

   bit 7,d
   call NZ,l_neg_de

   bit 7,h
   call NZ,l_neg_hl

   ; multiply & check for overflow

   call l_small_mul_16_16x16


   pop af
   ret P

   ; correct sign of result

   jp l_neg_hl
