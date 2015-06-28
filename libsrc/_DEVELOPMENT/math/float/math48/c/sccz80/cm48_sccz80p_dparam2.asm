
SECTION code_fp_math48

PUBLIC cm48_sccz80p_dparam2

EXTERN am48_dloadb

cm48_sccz80p_dparam2:

   ; read two math48 doubles from the stack
   ;
   ; enter : stack = double x, doubly y, ret1, ret0
   ;
   ; exit  : AC'= y
   ;         AC = x

   ld hl,15
   add hl,sp
   
   call am48_dloadb

   ld hl,9
   add hl,sp
   
   jp am48_dloadb
