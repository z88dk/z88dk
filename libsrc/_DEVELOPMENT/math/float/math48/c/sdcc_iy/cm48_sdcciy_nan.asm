
; float nan(const char *tagp) __z88dk_fastcall

SECTION code_fp_math48

PUBLIC cm48_sdcciy_nan

EXTERN am48_nan, cm48_sdcciyp_m482d

cm48_sdcciy_nan:

   call am48_nan
   
   jp cm48_sdcciyp_m482d
