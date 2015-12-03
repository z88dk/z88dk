
SECTION code_clib
SECTION code_math

PUBLIC l_small_mul_40_32x8

l_small_mul_40_32x8:

   ; multiplication of a 32-bit number and an 8-bit number into 40-bit result
   ;
   ; enter : dehl = 32-bit multiplicand
   ;            a = 8-bit multiplicand
   ;
   ; exit  : adehl = 40-bit product
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   push hl
   ld hl,0
   
   exx
   
   pop de
   ld hl,0

   ;  de'de = 32-bit multiplicand
   ;      a = 8-bit multiplicand
   ;  hl'hl = 0

   ld bc,0x0800

   add a,a
   jr loop_enter
   
loop:

   add hl,hl
   exx
   adc hl,hl
   exx
   adc a,a

loop_enter:

   jr nc, loop_end
   
   add hl,de
   exx
   adc hl,de
   exx
   adc a,c

loop_end:

   djnz loop

   ; ahl'hl = product

   push hl
   exx
   pop de
   
   ex de,hl
   ret
