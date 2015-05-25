
; double __CALLEE__ fdim(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fdim

EXTERN lm48_fdim, cm48_sccz80p_collect_2

cm48_sccz80_fdim:

   call cm48_sccz80p_collect_2
   
   ; AC = x
   ; AC'= y
   
   exx
   jp lm48_fdim
