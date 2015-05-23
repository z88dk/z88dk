
; double __CALLEE__ fmin(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fmin

EXTERN lm48_fmin, cm48_sccz80p_collect_2

cm48_sccz80_fmin:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   
   exx
   
   jp lm48_fmin
