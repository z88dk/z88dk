
; float acos(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_acos

EXTERN cm48_sdccixp_dx2m48, am48_acos, cm48_sdccixp_m482d

cm48_sdccix_acos:

   call cm48_sdccixp_dx2m48
   
   call am48_acos
   
   jp cm48_sdccixp_m482d
