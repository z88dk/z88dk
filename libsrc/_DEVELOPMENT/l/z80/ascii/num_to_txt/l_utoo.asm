
XLIB l_utoo

XDEF l1_utoo_lz, l1_utoo_nlz
XDEF l2_utoo_lz, l2_utoo_nlz
XDEF l3_utoo_lz, l3_utoo_nlz

LIB l_setmem_de

   scf

l_utoo:

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
   jp three_nlz

loop0:
               l1_utoo_nlz:
   add hl,hl
   adc a,a
               l2_utoo_nlz:
               two_nlz:
   add hl,hl
   adc a,a
               l3_utoo_nlz:
               three_nlz:
   add hl,hl
   adc a,a
   
   jr nz, write
   djnz loop0
   
   ld a,'0'
   ld (de),a
   inc de
   
   ret

leading_zeroes:

   xor a
   jp three_lz

loop1:
               l1_utoo_lz:
   add hl,hl
   adc a,a
               l2_utoo_lz:
               two_lz:
   add hl,hl
   adc a,a
               l3_utoo_lz:
               three_lz:
   add hl,hl
   adc a,a

write:

   add a,'0'
   ld (de),a
   inc de
   
   djnz loop1
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
   jp two_lz
