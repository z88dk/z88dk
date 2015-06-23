
; float atanh(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_atanh

EXTERN cm48_sdccixp_dx2m48, am48_atanh, cm48_sdccixp_m482d

cm48_sdccix_atanh:

   call cm48_sdccixp_dx2m48
   
   call am48_atanh
   
   jp cm48_sdccixp_m482d
