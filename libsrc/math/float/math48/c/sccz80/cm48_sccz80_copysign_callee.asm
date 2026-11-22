
; double __CALLEE__ copysign(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_copysign_callee

EXTERN am48_copysign, cm48_sccz80p_dcallee2

cm48_sccz80_copysign_callee:

   call cm48_sccz80p_dcallee2
   
   ; AC'= y
   ; AC = x
   
   exx
   jp am48_copysign
