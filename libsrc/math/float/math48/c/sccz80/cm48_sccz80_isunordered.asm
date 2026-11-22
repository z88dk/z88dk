
; int isunordered(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_isunordered

EXTERN am48_isunordered, cm48_sccz80p_dread2

cm48_sccz80_isunordered:

   call cm48_sccz80p_dread2
   
   ; AC'= y
   ; AC = x
   
   jp am48_isunordered
