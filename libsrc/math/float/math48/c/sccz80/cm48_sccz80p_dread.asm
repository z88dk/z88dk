
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dread1, cm48_sccz80p_dread2

EXTERN cm48_sccz80p_dload

cm48_sccz80p_dread2:

   ; Read two sccz80 doubles from the stack
   ;
   ; enter : stack = double x, doubly y, ret1, ret0
   ;
   ; exit  : AC'= y (math48)
   ;         AC = x (math48)

   ld hl,10
   add hl,sp
   
   call cm48_sccz80p_dload

cm48_sccz80p_dread1:

   ld hl,4
   add hl,sp
   
   jp cm48_sccz80p_dload
