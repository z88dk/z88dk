
; double __CALLEE__ fmod(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fmod

EXTERN lm48_fmod, cm48_sccz80p_collect_2

cm48_sccz80_fmod:

   call cm48_sccz80p_collect_2
   
   ; AC'= y
   ; AC = x
   
   exx
   jp lm48_fmod
