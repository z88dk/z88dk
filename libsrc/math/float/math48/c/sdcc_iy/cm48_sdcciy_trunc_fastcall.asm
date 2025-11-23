
; float trunc(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_trunc_fastcall

EXTERN cm48_sdcciyp_dx2m48, am48_trunc, cm48_sdcciyp_m482d

cm48_sdcciy_trunc_fastcall:

   call cm48_sdcciyp_dx2m48
   
   call am48_trunc
   
   jp cm48_sdcciyp_m482d
