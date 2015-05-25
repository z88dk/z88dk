
; double __CALLEE__ hypot(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_hypot

EXTERN lm48_hypot, cm48_sccz80p_collect_2

cm48_sccz80_hypot:

   call cm48_sccz80p_collect_2
   
   ; AC'= y
   ; AC = x
   
   jp lm48_hypot
