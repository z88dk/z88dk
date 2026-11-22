
; int __CALLEE__ isunordered(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_isunordered_callee

EXTERN am48_isunordered, cm48_sccz80p_dcallee2

cm48_sccz80_isunordered_callee:

   call cm48_sccz80p_dcallee2
   
   ; AC'= y
   ; AC = x
   
   jp am48_isunordered
