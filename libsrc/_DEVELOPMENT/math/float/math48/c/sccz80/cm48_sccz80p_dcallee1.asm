
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dcallee1

cm48_sccz80p_dcallee1:

   ; collect one math48 double parameter from the stack.
   ;
   ; enter : stack = double x, return
   ;
   ; exit  : AC'= x
   ;
   ; uses  : ix, bc', de', hl'
   
   pop ix
   
   exx
   
   pop hl                      ; AC'= x
   pop de
   pop bc
   
   exx

   jp (ix)
