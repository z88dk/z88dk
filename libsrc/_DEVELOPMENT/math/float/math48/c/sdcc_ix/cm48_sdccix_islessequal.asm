
; int islessequal(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdccix_islessequal

EXTERN am48_islessequal, cm48_sdccixp_dcallee2

cm48_sdccix_islessequal:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x

   jp am48_islessequal
