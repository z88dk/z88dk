
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_push_mhl

____sdcc_4_push_mhl:

   pop af
   push af
   push af
   push af
   
   push de

   ex de,hl
   
   ld hl,4
   add hl,sp
   
   ex de,hl
   
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a
   
   pop de
   
   inc bc
   inc bc
   inc bc
   
   ret
