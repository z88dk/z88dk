
; double fdim(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sccz80_fdim

EXTERN am48_fdim, cm48_sccz80p_dread2

cm48_sccz80_fdim:

   call cm48_sccz80p_dread2
   
   ; AC = x
   ; AC'= y
   
   exx
   jp am48_fdim
