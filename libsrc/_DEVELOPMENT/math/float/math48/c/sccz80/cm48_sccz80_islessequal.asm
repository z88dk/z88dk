
; int __CALLEE__ islessequal(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_islessequal

EXTERN am48_islessequal, cm48_sccz80p_dcallee2

cm48_sccz80_islessequal:

   call cm48_sccz80p_dcallee2
   
   ; AC'= y
   ; AC = x
   
   jp am48_islessequal
