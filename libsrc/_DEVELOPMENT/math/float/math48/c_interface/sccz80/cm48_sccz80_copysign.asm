
; double __CALLEE__ copysign(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_copysign

EXTERN lm48_copysign, cm48_sccz80p_collect_2

cm48_sccz80_copysign:

   call cm48_sccz80p_collect_2
   
   ; AC'= y
   ; AC = x
   
   exx
   jp lm48_copysign
