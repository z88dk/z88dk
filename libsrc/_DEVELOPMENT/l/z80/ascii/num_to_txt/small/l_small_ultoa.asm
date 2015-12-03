
SECTION code_clib
SECTION code_l

PUBLIC l_small_ultoa

l_small_ultoa:

   ; write unsigned long decimal to ascii buffer
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  :   de = char *buffer (one byte past last char written)
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl, bc', hl'

   exx
   
   ld hl,$ffff
   
   ld bc,0+256
   push bc
   push bc
   
   ld bc,-10+256
   push bc
   push hl
   
   ld bc,-1000+256
   push bc
   push hl
   
   ld bc,-10000+256
   push bc
   push hl
   
   ld bc,$7a60                 ; -100,000 (LSW + 256)
   push bc
   ld bc,$fffe
   push bc
   
   ld bc,$bec0                 ; -1,000,000 (LSW + 256)
   push bc
   ld bc,$fff0
   push bc
   
   ld bc,$6a80                 ; -10,000,000 (LSW + 256)
   push bc
   ld bc,$ff67
   push bc
   
   ld bc,$2000                 ; -100,000,000 (LSW + 256)
   push bc
   ld bc,$fa0a
   push bc
   
   ld bc,$3600                 ; -1,000,000,000
   push bc
   ld bc,$c465

   exx
   
   push de
   exx
   pop hl
   exx

   ld e,c
   ld d,b
   
   pop bc
   
   ; hl'hl = unsigned long
   ; bc'bc = first divisor
   ;    de = char *
   ; carry set to write leading zeroes

   jr c, leading_zeroes

no_leading_zeroes:

   call divide
   cp '0'
   jr nz, write
   
   exx
   pop bc
   exx
   pop bc
   
   djnz no_leading_zeroes
   jr write1s

leading_zeroes:

   call divide

write:

   ld (de),a
   inc de
   
   exx
   pop bc
   exx
   pop bc
   
   djnz leading_zeroes

write1s:

   ld a,l
   add a,'0'
   
   ld (de),a
   inc de
   
   ret

divide:

   ; hl'hl = dividend
   ; bc'bc = divisor
   
   ld a,'0'-1

divloop:

   inc a
   
   add hl,bc
   exx
   adc hl,bc
   exx
   
   jr c, divloop
   
   sbc hl,bc
   exx
   sbc hl,bc
   exx
   
   ret
