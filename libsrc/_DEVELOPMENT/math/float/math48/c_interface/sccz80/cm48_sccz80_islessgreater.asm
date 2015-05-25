
; int __CALLEE__ islessgreater(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_islessgreater

EXTERN lm48_islessgreater, cm48_sccz80p_collect_2

cm48_sccz80_islessgreater:

   call cm48_sccz80p_collect_2
   
   ; AC'= y
   ; AC = x
   
   jp lm48_islessgreater
