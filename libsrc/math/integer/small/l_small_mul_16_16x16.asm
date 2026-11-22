
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
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   inc h
   dec h
   jr z, eight_bit_1
   
   inc d
   dec d
   jr z, eight_bit_0

   ld c,l
   ld a,h
   ld b,16

   jr rejoin

eight_bit_0:

   ex de,hl

eight_bit_1:

l_small_mul_16_16x8:

   ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
   ;
   ; enter :  l = 8-bit multiplicand
   ;         de = 16-bit multiplicand
   ;
   ; exit  : hl = 16-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, hl

   ld a,l
   ld b,8

rejoin:

   ld hl,0

loop_0:

   ; ac = 16-bit multiplicand
   ; de = 16-bit multiplicand
   ;  b = iterations

   add hl,hl
   
   rl c
   rla

   jr nc, loop_1
   add hl,de

loop_1:

   djnz loop_0
   
   or a
   ret
