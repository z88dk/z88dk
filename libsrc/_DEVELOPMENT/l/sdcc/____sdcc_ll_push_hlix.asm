
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_push_hlix

____sdcc_ll_push_hlix:

   push ix
   pop de
   
   add hl,de
   ex de,hl
   
   ld hl,-6
   add hl,sp
   
   pop af
   ld sp,hl
   push af
   
   ex de,hl
   
   ldi
   ldi
   ldi
   ldi
   
   ldi
   ldi
   ldi
   ldi
   
   ret
