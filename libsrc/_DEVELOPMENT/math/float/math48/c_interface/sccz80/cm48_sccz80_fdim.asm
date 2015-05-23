
; double __CALLEE__ fdim(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fdim, cm48_sccz80p_collect_2

EXTERN lm48_fdim

cm48_sccz80_fdim:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
      
   jp lm48_fdim
