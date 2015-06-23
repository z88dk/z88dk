
; float exp(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_exp

EXTERN cm48_sdccixp_dx2m48, am48_exp, cm48_sdccixp_m482d

cm48_sdccix_exp:

   call cm48_sdccixp_dx2m48
   
   call am48_exp
   
   jp cm48_sdccixp_m482d
