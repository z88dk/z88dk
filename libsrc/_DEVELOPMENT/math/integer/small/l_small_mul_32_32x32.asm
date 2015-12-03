
; 2000 djm
; 2007 aralbrec - use bcbc' rather than bytes indexed by ix per djm suggestion

SECTION code_clib
SECTION code_math

PUBLIC l_small_mul_32_32x32, l0_small_mul_32_32x32

l_small_mul_32_32x32:

   ; multiplication of two 32-bit numbers into a 32-bit product
   ;
   ; enter : dehl = 32-bit multiplicand
   ;         dehl'= 32-bit multiplicand (more leading zeroes = better performance)
   ;
   ; exit  : dehl = 32-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   xor a
   push hl
   exx
   ld c,l
   ld b,h
   pop hl
   push de
   ex de,hl
   ld l,a
   ld h,a
   exx
   pop bc
   ld l,a
   ld h,a

l0_small_mul_32_32x32:

   ; dede' = 32-bit multiplicand
   ; bcbc' = 32-bit multiplicand
   ; hlhl' = 0

   ld a,b
   ld b,32

loop_0:

   rra
   rr c
   exx
   rr b
   rr c
   jr nc, loop_1
   
   add hl,de
   exx
   adc hl,de
   exx

loop_1:

   sla e
   rl d
   exx
   rl e
   rl d
   
   djnz loop_0

   push hl
   exx
   pop de
   
   or a
   ret
