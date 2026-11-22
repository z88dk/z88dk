
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dcallee1, cm48_sccz80p_dcallee1_0

cm48_sccz80p_dcallee1:

   ; collect one sccz80 double parameter from the stack.
   ;
   ; enter : stack = double x, return_0, return_1
   ;
   ; exit  :    AC'= x
   ;         stack = return_0
   ;
   ; uses  : ix, af', bc', de', hl'

   exx

cm48_sccz80p_dcallee1_0:

   pop ix
   pop af

   ex af,af'
   
   dec sp                      ; AC'= x
   pop hl
   pop de
   pop bc
   dec sp
   pop af
   ld l,a

   ex af,af'
   exx
   
   push af
   jp (ix)
