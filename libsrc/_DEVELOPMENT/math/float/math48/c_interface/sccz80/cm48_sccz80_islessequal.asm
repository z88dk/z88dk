
; int __CALLEE__ islessequal(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_islessequal

EXTERN lm48_islessequal, cm48_sccz80p_collect_2

cm48_sccz80_islessequal:

   call cm48_sccz80p_collect_2
   
   ; AC'= y
   ; AC = x
   
   jp lm48_islessequal
