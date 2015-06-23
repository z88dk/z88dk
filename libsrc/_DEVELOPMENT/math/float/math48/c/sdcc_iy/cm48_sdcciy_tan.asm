
; float tan(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_tan

EXTERN cm48_sdcciyp_dx2m48, am48_tan, cm48_sdcciyp_m482d

cm48_sdcciy_tan:

   call cm48_sdcciyp_dx2m48
   
   call am48_tan
   
   jp cm48_sdcciyp_m482d
