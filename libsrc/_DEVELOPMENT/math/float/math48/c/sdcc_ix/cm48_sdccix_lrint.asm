
; long lrint(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdccix_lrint

EXTERN cm48_sdccixp_dx2m48, am48_lrint

cm48_sdccix_lrint:

   call cm48_sdccixp_dx2m48
   
   jp am48_lrint
