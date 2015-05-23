
; int __CALLEE__ isgreaterequal(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_isgreaterequal

EXTERN lm48_isgreaterequal, cm48_sccz80p_collect_2

cm48_sccz80_isgreaterequal:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   
   exx
   
   jp lm48_isgreaterequal
