
; int ilogb(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_ilogb_fastcall

EXTERN cm48_sdccixp_dx2m48, am48_ilogb

cm48_sdccix_ilogb_fastcall:

   call cm48_sdccixp_dx2m48
   
   jp am48_ilogb
