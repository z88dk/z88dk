
; double __CALLEE__ atan2(double y, double x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_atan2_callee

EXTERN am48_atan2, cm48_sccz80p_dcallee2

cm48_sccz80_atan2_callee:

   call cm48_sccz80p_dcallee2
   
   ; AC'= x
   ; AC = y
   
   jp am48_atan2
