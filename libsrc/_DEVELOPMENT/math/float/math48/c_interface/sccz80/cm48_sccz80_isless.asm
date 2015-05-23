
; int __CALLEE__ isless(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_isless

EXTERN lm48_isless, cm48_sccz80p_collect_2

cm48_sccz80_isless:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   
   exx
   
   jp lm48_isless
