
; int __CALLEE__ isgreater(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_isgreater

EXTERN lm48_isgreater, cm48_sccz80p_collect_2

cm48_sccz80_isgreater:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   
   exx
   
   jp isgreater
