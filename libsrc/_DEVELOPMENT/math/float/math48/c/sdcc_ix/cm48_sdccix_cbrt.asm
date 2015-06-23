
; float cbrt(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_cbrt

EXTERN cm48_sdccixp_dx2m48, am48_cbrt, cm48_sdccixp_m482d

cm48_sdccix_cbrt:

   call cm48_sdccixp_dx2m48
   
   call am48_cbrt
   
   jp cm48_sdccixp_m482d
