
; int __CALLEE__ isunordered(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_isunordered

EXTERN lm48_isunordered, cm48_sccz80p_collect_2

cm48_sccz80_isunordered:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   
   jp lm48_isunordered
