
SECTION code_clib
SECTION code_l

PUBLIC l_bitset_locate

l_bitset_locate:

   ; Locate the char in a 32-byte bitmap
   ;
   ; enter :  a = char
   ;
   ; exit  : hl = byte offset
   ;          a = bit mask
   ;
   ; uses  : af, b, hl

   ld l,a
   srl l
   srl l
   srl l
      
   and $07
   inc a
   ld b,a
   
   xor a
   ld h,a
   scf
   
bit_loop:

   rla
   djnz bit_loop

   ret
