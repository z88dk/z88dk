
; float acosh(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_acosh

EXTERN cm48_sdccixp_dx2m48, am48_acosh, cm48_sdccixp_m482d

cm48_sdccix_acosh:

   call cm48_sdccixp_dx2m48
   
   call am48_acosh
   
   jp cm48_sdccixp_m482d
