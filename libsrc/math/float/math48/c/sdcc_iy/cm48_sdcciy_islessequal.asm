
; int islessequal(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_islessequal

EXTERN am48_islessequal, cm48_sdcciyp_dread2

cm48_sdcciy_islessequal:

   call cm48_sdcciyp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_islessequal
