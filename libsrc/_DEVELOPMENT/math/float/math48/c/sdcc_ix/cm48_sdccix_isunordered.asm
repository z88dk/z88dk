
; int isunordered(double x, double y)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_isunordered

EXTERN am48_isunordered, cm48_sdccixp_dread2

cm48_sdccix_isunordered:

   call cm48_sdccixp_dread2
   
   ; AC'= y
   ; AC = x

   jp am48_isunordered
