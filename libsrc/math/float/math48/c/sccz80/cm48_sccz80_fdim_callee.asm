
; double __CALLEE__ fdim(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fdim_callee

EXTERN am48_fdim, cm48_sccz80p_dcallee2

cm48_sccz80_fdim_callee:

   call cm48_sccz80p_dcallee2
   
   ; AC = x
   ; AC'= y
   
   exx
   jp am48_fdim
