
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dcallee1

cm48_sccz80p_dcallee1:

   ; collect one math48 double parameter from the stack.
   ;
   ; enter : stack = double x, return_0, return_1
   ;
   ; exit  :    AC'= x
   ;         stack = return_0
   ;
   ; uses  : ix, bc', de', hl'
   
   pop ix
   pop af
   
   exx
   
   pop hl                      ; AC'= x
   pop de
   pop bc
   
   exx

   push af
   jp (ix)
