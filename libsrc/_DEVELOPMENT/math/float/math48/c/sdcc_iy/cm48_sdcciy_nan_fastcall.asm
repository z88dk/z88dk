
; float nan(const char *tagp) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_nan_fastcall

EXTERN am48_nan, cm48_sdcciyp_m482d

cm48_sdcciy_nan_fastcall:

   call am48_nan
   
   jp cm48_sdcciyp_m482d
