
; int islessgreater(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_islessgreater

EXTERN am48_islessgreater, cm48_sccz80p_dread2

cm48_sccz80_islessgreater:

   call cm48_sccz80p_dread2
   
   ; AC'= y
   ; AC = x
   
   jp am48_islessgreater
