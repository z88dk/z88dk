
; int __CALLEE__ isless(double x, double y)

SECTION code_fp_math48

PUBLIC cm48_sccz80_isless

EXTERN am48_isless, cm48_sccz80p_dcallee2

cm48_sccz80_isless:

   call cm48_sccz80p_dcallee2
   
   ; AC'= y
   ; AC = x
   
   jp am48_isless
