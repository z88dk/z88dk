
SECTION code_fp_math48

PUBLIC lm48__dhexpop

lm48__dhexpop:

   pop af
   
   exx
   
   dec sp
   
   pop hl
   pop de
   pop bc
   
   ld l,0
   
   exx
   
   push af
   ret
