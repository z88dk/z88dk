
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dcallee2

cm48_sccz80p_dcallee2:

   ; collect two math48 double parameters from the stack.
   ;
   ; enter : stack = double x, double y, return_1, return_0
   ;
   ; exit  : AC'= y
   ;         AC = x
   ;         stack = return_1
   
   pop ix
   pop af
   
   pop hl                      ; AC'= y
   pop de
   pop bc
   
   exx
   
   pop hl                      ; AC = x
   pop de
   pop bc
   
   push af
   jp (ix)
