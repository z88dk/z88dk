
SECTION code_clib
SECTION code_fp_math48

PUBLIC am48_dpop

am48_dpop:

   ; pop AC' from stack
   ;
   ; enter : stack = double, ret
   ;
   ; exit  : AC'= double
   ;
   ; uses : af, bc', de', hl'
   
   exx
   
   pop af
   
   pop hl
   pop de
   pop bc
   
   push af
   
   exx
   ret
