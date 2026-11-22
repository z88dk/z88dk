
SECTION code_clib
SECTION code_l

PUBLIC l_fast_utoo

PUBLIC l1_fast_utoo_lz, l1_fast_utoo_nlz
PUBLIC l2_fast_utoo_lz, l2_fast_utoo_nlz
PUBLIC l3_fast_utoo_lz, l3_fast_utoo_nlz

EXTERN l_setmem_de

l_fast_utoo:

   ; write unsigned octal number to ascii buffer
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
   
   ld b,6
   jr c, leading_zeroes

no_leading_zeroes:

   xor a
   jr three_nlz

loop_nlz:
               l1_fast_utoo_nlz:
   add hl,hl
   adc a,a
               l2_fast_utoo_nlz:
               two_nlz:
   add hl,hl
   adc a,a
               l3_fast_utoo_nlz:
               three_nlz:
   add hl,hl
   adc a,a
   
   jr nz, write
   djnz loop_nlz
   
   ld a,'0'
   ld (de),a
   inc de
   
   ret

leading_zeroes:

   xor a
   jr three_lz

loop_lz:
               l1_fast_utoo_lz:
   add hl,hl
   adc a,a
               l2_fast_utoo_lz:
               two_lz:
   add hl,hl
   adc a,a
               l3_fast_utoo_lz:
               three_lz:
   add hl,hl
   adc a,a

write:

   add a,'0'
   ld (de),a
   inc de
   
   xor a
   djnz loop_lz
   
   scf
   ret


eight_bit:

   ld b,3
   ld a,h
   ld h,l
   
   jr nc, two_nlz
   
   ld a,'0'
   call l_setmem_de - 6
   
   xor a
   jr two_lz
