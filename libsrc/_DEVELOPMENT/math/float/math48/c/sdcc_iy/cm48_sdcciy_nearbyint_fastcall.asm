
; float nearbyint(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_nearbyint_fastcall

EXTERN cm48_sdcciyp_dx2m48, am48_nearbyint, cm48_sdcciyp_m482d

cm48_sdcciy_nearbyint_fastcall:

   call cm48_sdcciyp_dx2m48
   
   call am48_nearbyint
   
   jp cm48_sdcciyp_m482d
