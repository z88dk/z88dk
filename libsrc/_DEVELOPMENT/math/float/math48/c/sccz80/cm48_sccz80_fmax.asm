
; double fmax(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fmax

EXTERN am48_fmax, cm48_sccz80p_dread2

cm48_sccz80_fmax:

   call cm48_sccz80p_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_fmax
