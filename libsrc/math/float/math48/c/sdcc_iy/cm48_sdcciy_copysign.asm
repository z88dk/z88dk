
; float copysign(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_copysign

EXTERN cm48_sdcciyp_dread2, l0_cm48_sdcciy_copysign_callee

cm48_sdcciy_copysign:

   call cm48_sdcciyp_dread2

   ; AC'= y
   ; AC = x

   jp l0_cm48_sdcciy_copysign_callee
