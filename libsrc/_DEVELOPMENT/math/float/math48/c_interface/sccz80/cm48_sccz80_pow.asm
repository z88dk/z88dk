
; double __CALLEE__ pow(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_pow

EXTERN lm48_pow, cm48_sccz80p_collect_2

cm48_sccz80_pow:

   call cm48_sccz80p_collect_2
   
   ; AC'= y
   ; AC = x
   
   exx
   jp lm48_pow
