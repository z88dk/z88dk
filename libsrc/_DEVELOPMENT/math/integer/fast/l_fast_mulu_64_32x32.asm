
; 2014 aralbrec, modified from
; zx spectrum rom @ address $30f0
; http://www.wearmouth.demon.co.uk/zx82.htm
; fast optimization not complete

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_64_32x32, l0_fast_mulu_64_32x32

l_fast_mulu_64_32x32:

   ; multiplication of two 32-bit numbers into a 64-bit product
   ;
   ; enter : dehl = 32-bit multiplicand (more zeros = better performance)
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : dehl dehl' = 64-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   xor a
   ld c,l
   ld b,h
   ld l,a
   ld h,a
   push de
   exx
   pop bc
   push hl
   ld l,a
   ld h,a
   exx
   pop de

l0_fast_mulu_64_32x32:

   ; bc'bc = 32-bit multiplicand
   ; de'de = 32-bit multiplicand
   ; hl'hl = 0

   ld a,b
   ld b,33
   
   jr start

loop_0:

   jr nc, loop_1

   add hl,de
   exx
   adc hl,de
   exx

loop_1:

   exx
   rr h
   rr l
   exx
   rr h
   rr l

start:

   exx
   rr b
   rr c
   exx
   rra
   rr c
   
   djnz loop_0

   ; result = hl' hl bc' ac

   push bc
   exx
   ex (sp),hl
   ld h,a
   ld e,c
   ld d,b
   exx
   pop de
   
   ret
