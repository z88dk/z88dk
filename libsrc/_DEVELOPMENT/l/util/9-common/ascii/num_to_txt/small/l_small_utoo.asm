
SECTION code_clib
SECTION code_l

PUBLIC l_small_utoo

PUBLIC l2_small_utoo_lz, l2_small_utoo_nlz
PUBLIC l3_small_utoo_lz, l3_small_utoo_nlz

l_small_utoo:

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

   ld b,6
   jr c, leading_zeroes

no_leading_zeroes:

   xor a
   jr three_nlz

loop_nlz:

   add hl,hl
   adc a,a

l2_small_utoo_nlz:

   add hl,hl
   adc a,a

l3_small_utoo_nlz:
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

   add hl,hl
   adc a,a

l2_small_utoo_lz:

   add hl,hl
   adc a,a

l3_small_utoo_lz:
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
