
; double __CALLEE__ fma(double x, double y, double z)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fma

EXTERN lm48_fma, cm48_sccz80p_collect_2

cm48_sccz80_fma:

   call cm48_sccz80p_collect_2
   
   ; AC'= x
   ; AC = y
   ; stack = z, ret
   
   exx
   
   jp lm48_fma
