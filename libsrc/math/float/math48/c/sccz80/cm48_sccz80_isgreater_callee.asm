
; int __CALLEE__ isgreater(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_isgreater_callee

EXTERN am48_isgreater, cm48_sccz80p_dcallee2

cm48_sccz80_isgreater_callee:

   call cm48_sccz80p_dcallee2
   
   ; AC'= y
   ; AC = x
   
   jp am48_isgreater
