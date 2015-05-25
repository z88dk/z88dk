
; double __CALLEE__ atan2(double y, double x)

SECTION code_fp_math48

PUBLIC cm48_sccz80_atan2

EXTERN lm48_atan2, cm48_sccz80p_collect_2

cm48_sccz80_atan2:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   
   jp lm48_atan2
