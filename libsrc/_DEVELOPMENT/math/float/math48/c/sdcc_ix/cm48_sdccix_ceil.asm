
; float ceil(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_ceil

EXTERN cm48_sdccixp_dx2m48, am48_ceil, cm48_sdccixp_m482d

cm48_sdccix_ceil:

   call cm48_sdccixp_dx2m48
   
   call am48_ceil
   
   jp cm48_sdccixp_m482d
