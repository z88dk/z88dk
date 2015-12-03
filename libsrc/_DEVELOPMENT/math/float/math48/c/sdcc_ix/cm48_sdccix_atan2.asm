
; float atan2(float y, float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_atan2

EXTERN cm48_sdccixp_dread2, l0_cm48_sdccix_atan2_callee

cm48_sdccix_atan2:

   call cm48_sdccixp_dread2
   
   ; AC = x
   ; AC'= y
   
   jp l0_cm48_sdccix_atan2_callee
