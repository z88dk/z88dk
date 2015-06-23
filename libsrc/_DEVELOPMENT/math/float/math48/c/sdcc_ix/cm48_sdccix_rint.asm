
; float rint(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_rint

EXTERN cm48_sdccixp_dx2m48, am48_rint, cm48_sdccixp_m482d

cm48_sdccix_rint:

   call cm48_sdccixp_dx2m48
   
   call am48_rint
   
   jp cm48_sdccixp_m482d
