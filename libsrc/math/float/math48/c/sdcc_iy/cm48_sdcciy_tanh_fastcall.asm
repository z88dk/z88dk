
; float tanh(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_tanh_fastcall

EXTERN cm48_sdcciyp_dx2m48, am48_tanh, cm48_sdcciyp_m482d

cm48_sdcciy_tanh_fastcall:

   call cm48_sdcciyp_dx2m48
   
   call am48_tanh
   
   jp cm48_sdcciyp_m482d
