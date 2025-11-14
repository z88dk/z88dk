
; int isunordered(double x, double y) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_isunordered_callee

EXTERN am48_isunordered, cm48_sdccixp_dcallee2

cm48_sdccix_isunordered_callee:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x

   jp am48_isunordered
