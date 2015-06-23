
; int ilogb(float x) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_ilogb

EXTERN cm48_sdcciyp_dx2m48, am48_ilogb

cm48_sdcciy_ilogb:

   call cm48_sdcciyp_dx2m48
   
   jp am48_ilogb
