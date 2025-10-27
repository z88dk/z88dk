
; int isless(float x, float y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_isless

EXTERN am48_isless, cm48_sdccixp_dread2

cm48_sdccix_isless:

   call cm48_sdccixp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_isless
