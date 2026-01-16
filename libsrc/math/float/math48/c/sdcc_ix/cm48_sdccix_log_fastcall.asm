
; float log(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_log_fastcall

EXTERN cm48_sdccixp_dx2m48, am48_log, cm48_sdccixp_m482d

cm48_sdccix_log_fastcall:

   call cm48_sdccixp_dx2m48
   
   call am48_log
   
   jp cm48_sdccixp_m482d
