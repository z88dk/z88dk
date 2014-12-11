
SECTION code_l

PUBLIC l_small_utoa

l_small_utoa:

   ; write unsigned decimal integer to ascii buffer
   ;
   ; enter : hl = unsigned integer
   ;         de = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de = char *buffer (one byte past last char written)
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld bc,0+256
   push bc
   
   ld bc,-10+256
   push bc
   
   ld bc,-100+256
   push bc
   
   ld bc,-1000+256
   push bc
   
   ld bc,-10000
   jr c, leading_zeroes

no_leading_zeroes:

   call divide
   cp '0'
   jr nz, write
   
   pop bc
   djnz no_leading_zeroes
   
   jr write1s

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
   jr c, divloop
   
   sbc hl,bc
   ret
