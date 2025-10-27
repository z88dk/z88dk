
; int islessgreater(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_islessgreater

EXTERN am48_islessgreater, cm48_sdccixp_dread2

cm48_sdccix_islessgreater:

   call cm48_sdccixp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_islessgreater
