
; float sqrt(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_sqrt

EXTERN cm48_sdcciyp_dx2m48, am48_sqrt, cm48_sdcciyp_m482d

cm48_sdcciy_sqrt:

   call cm48_sdcciyp_dx2m48
   
   call am48_sqrt
   
   jp cm48_sdcciyp_m482d
