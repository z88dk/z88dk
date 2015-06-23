
; float expm1(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_expm1

EXTERN cm48_sdcciyp_dx2m48, am48_expm1, cm48_sdcciyp_m482d

cm48_sdcciy_expm1:

   call cm48_sdcciyp_dx2m48
   
   call am48_expm1
   
   jp cm48_sdcciyp_m482d
