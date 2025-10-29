
; double __CALLEE__ pow(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_pow_callee

EXTERN am48_pow, cm48_sccz80p_dcallee2

cm48_sccz80_pow_callee:

   call cm48_sccz80p_dcallee2
   
   ; AC'= y
   ; AC = x
   
   exx
   jp am48_pow
