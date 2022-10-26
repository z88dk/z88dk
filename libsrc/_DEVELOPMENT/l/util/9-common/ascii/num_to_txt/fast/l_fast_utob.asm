
SECTION code_clib
SECTION code_l

PUBLIC l_fast_utob

EXTERN l_setmem_de

l_fast_utob:

   ; write unsigned binary number to ascii buffer
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de = char *buffer (one byte past last char written)
   ;         carry set if in write loop
   ;
   ; uses  : af, b, de, hl

   inc h
   dec h
   jr z, eight_bit

   ld b,16
   jr c, leading_zeroes


no_leading_zeroes:

   add hl,hl
   jr c, write
   
   djnz no_leading_zeroes
   
   ld a,'0'
   ld (de),a
   inc de
   
   ret


leading_zeroes:

   add hl,hl

write:

   ld a,'0'
   adc a,0
   
   ld (de),a
   inc de
   
   djnz leading_zeroes
   
   scf
   ret


eight_bit:

   ld b,8
   ld h,l
   
   jr nc, no_leading_zeroes
   
   ld a,'0'
   call l_setmem_de - 16
   
   jr leading_zeroes
