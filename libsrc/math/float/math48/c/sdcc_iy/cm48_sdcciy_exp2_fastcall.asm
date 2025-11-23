
; float exp2(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_exp2_fastcall

EXTERN cm48_sdcciyp_dx2m48, am48_exp2, cm48_sdcciyp_m482d

cm48_sdcciy_exp2_fastcall:

   call cm48_sdcciyp_dx2m48
   
   call am48_exp2
   
   jp cm48_sdcciyp_m482d
