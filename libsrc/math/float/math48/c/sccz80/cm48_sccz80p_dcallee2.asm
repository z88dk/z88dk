
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dcallee2

cm48_sccz80p_dcallee2:

   ; collect two sccz80 double parameters from the stack.
   ;
   ; enter : stack = double x, double y, return_1, return_0
   ;
   ; exit  : AC'= y
   ;         AC = x
   ;         stack = return_1
   ;
   ; uses  : all except iy

   pop ix
   pop af
   
   ex af,af'
   
   dec sp                      ; AC'= y
   pop hl
   pop de
   pop bc
   dec sp
   pop af
   ld l,a

   exx

   dec sp                      ; AC = x
   pop hl
   pop de
   pop bc
   dec sp
   pop af
   ld l,a

   ex af,af'
   
   push af
   jp (ix)
