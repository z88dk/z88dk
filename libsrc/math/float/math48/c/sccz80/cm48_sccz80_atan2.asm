
; double atan2(double y, double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_atan2

EXTERN am48_atan2, cm48_sccz80p_dread2

cm48_sccz80_atan2:

   call cm48_sccz80p_dread2
   
   ; AC'= x
   ; AC = y
   
   jp am48_atan2
