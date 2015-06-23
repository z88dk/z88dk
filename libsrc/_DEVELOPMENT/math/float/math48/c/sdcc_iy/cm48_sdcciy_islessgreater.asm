
; int islessgreater(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdcciy_islessgreater

EXTERN am48_islessgreater, cm48_sdcciyp_dcallee2

cm48_sdcciy_islessgreater:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x

   jp am48_islessgreater
