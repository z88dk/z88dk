
; float cbrt(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_cbrt

EXTERN cm48_sdcciyp_dx2m48, am48_cbrt, cm48_sdcciyp_m482d

cm48_sdcciy_cbrt:

   call cm48_sdcciyp_dx2m48
   
   call am48_cbrt
   
   jp cm48_sdcciyp_m482d
