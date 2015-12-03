
; double fmin(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fmin

EXTERN am48_fmin, cm48_sccz80p_dread2

cm48_sccz80_fmin:

   call cm48_sccz80p_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_fmin
