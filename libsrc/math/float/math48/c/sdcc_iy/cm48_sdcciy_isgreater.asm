
; int isgreater(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_isgreater

EXTERN am48_isgreater, cm48_sdcciyp_dread2

cm48_sdcciy_isgreater:

   call cm48_sdcciyp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_isgreater
