
; float cosh(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_cosh_fastcall

EXTERN cm48_sdcciyp_dx2m48, am48_cosh, cm48_sdcciyp_m482d

cm48_sdcciy_cosh_fastcall:

   call cm48_sdcciyp_dx2m48
   
   call am48_cosh
   
   jp cm48_sdcciyp_m482d
