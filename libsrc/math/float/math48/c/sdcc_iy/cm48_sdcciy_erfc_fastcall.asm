
; float erfc(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_erfc_fastcall

EXTERN cm48_sdcciyp_dx2m48, am48_erfc, cm48_sdcciyp_m482d

cm48_sdcciy_erfc_fastcall:

   call cm48_sdcciyp_dx2m48
   
   call am48_erfc
   
   jp cm48_sdcciyp_m482d
