
; double fmod(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_fmod

EXTERN am48_fmod, cm48_sccz80p_dparam2

cm48_sccz80_fmod:

   call cm48_sccz80p_dparam2
   
   ; AC'= y
   ; AC = x
   
   exx
   jp am48_fmod
