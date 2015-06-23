
; float tgamma(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_tgamma

EXTERN cm48_sdccixp_dx2m48, am48_tgamma, cm48_sdccixp_m482d

cm48_sdccix_tgamma:

   call cm48_sdccixp_dx2m48
   
   call am48_tgamma
   
   jp cm48_sdccixp_m482d
