
; float exp2(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_exp2_fastcall

EXTERN cm48_sdccixp_dx2m48, am48_exp2, cm48_sdccixp_m482d

cm48_sdccix_exp2_fastcall:

   call cm48_sdccixp_dx2m48
   
   call am48_exp2
   
   jp cm48_sdccixp_m482d
