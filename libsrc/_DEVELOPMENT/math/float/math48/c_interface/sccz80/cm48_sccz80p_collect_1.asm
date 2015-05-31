
SECTION code_fp_math48

PUBLIC cm48_sccz80p_collect_1

cm48_sccz80p_collect_1:

   ; collect one double parameter from the stack.
   ;
   ; enter : stack = double x, return_1, return_0
   ;
   ; exit  : AC'= x
   ;         stack = return_1
   
   pop ix
   pop af
   
   exx
   
   pop hl                      ; AC'= x
   pop de
   pop bc
   
   exx

   push af
   jp (ix)
