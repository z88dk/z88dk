
; 2000 djm
; 2014 aralbrec - special case for 8-bit multiplicands

SECTION code_clib
SECTION code_math

PUBLIC l_small_mul_16_16x16, l_small_mul_16_16x8

l_small_mul_16_16x16:

   ; multiplication of two 16-bit numbers into a 16-bit product
   ;
   ; enter : de = 16-bit multiplicand
   ;         hl = 16-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;
   ; uses  : af, b, de, hl
   ld b, l
   ld a, h

   ld hl, 0
   REPT 8
       add hl, hl \ add a, a
       jr nc, $+3 \ add hl, de
   endr

   ld a, b
   REPT 8
       add hl, hl \ add a, a
       jr nc, $+3 \ add hl, de
   endr
   ret


l_small_mul_16_16x8:

   ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
   ;
   ; enter :  l = 8-bit multiplicand
   ;         de = 16-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;
   ; uses  : af, b, hl

   ld a, l
   ld hl, 0

   REPT 8
       add hl, hl \ add a, a
       jr nc, $+3 \ add hl, de
   endr

   ret
