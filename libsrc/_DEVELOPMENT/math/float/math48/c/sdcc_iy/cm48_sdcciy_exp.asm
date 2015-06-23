
; float exp(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_exp

EXTERN cm48_sdcciyp_dx2m48, am48_exp, cm48_sdcciyp_m482d

cm48_sdcciy_exp:

   call cm48_sdcciyp_dx2m48
   
   call am48_exp
   
   jp cm48_sdcciyp_m482d
