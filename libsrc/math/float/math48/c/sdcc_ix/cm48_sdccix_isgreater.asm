
; int isgreater(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_isgreater

EXTERN am48_isgreater, cm48_sdccixp_dread2

cm48_sdccix_isgreater:

   call cm48_sdccixp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_isgreater
