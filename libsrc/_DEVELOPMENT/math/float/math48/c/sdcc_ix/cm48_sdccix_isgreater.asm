
; int isgreater(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdccix_isgreater

EXTERN am48_isgreater, cm48_sdccixp_dcallee2

cm48_sdccix_isgreater:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x

   jp am48_isgreater
