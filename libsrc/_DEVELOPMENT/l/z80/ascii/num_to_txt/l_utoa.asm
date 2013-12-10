
XLIB l_utoa
XDEF l0_utoa

   scf

l_utoa:

   ; write unsigned decimal integer to ascii buffer
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de = char *buffer (one byte past last char written)
   ;
   ; uses  : af, bc, de, hl

   ld bc,0+256
   push bc
   
   ld bc,-10+256
   push bc
   
   inc h
   dec h
   jr z, eight_bit
   
   ld bc,-100+256
   push bc
   
   ld bc,-1000+256
   push bc
   
   ld bc,-10000

l0_utoa:

   jr c, leading_zeroes


no_leading_zeroes:

   call divide
   cp '0'
   jr nz, write
   
   pop bc
   djnz no_leading_zeroes
   
   jp write1s


leading_zeroes:

   call divide

write:

   ld (de),a
   inc de
   
   pop bc
   djnz leading_zeroes


write1s:

   ld a,l
   add a,'0'
   
   ld (de),a
   inc de
   ret


divide:

   ld a,'0'-1

divloop:

   inc a
   add hl,bc
   jp c, divloop
   
   sbc hl,bc
   ret

eight_bit:

   ld bc,-100
   jp nc, no_leading_zeroes
   
   ; write two leading zeroes to output string
   
   ld a,'0'
   ld (de),a
   inc de
   ld (de),a
   inc de
   
   jp leading_zeroes
