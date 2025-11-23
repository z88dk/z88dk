
; float pow(float x, float y) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_pow_callee, l0_cm48_sdcciy_pow_callee

EXTERN am48_pow, cm48_sdcciyp_dcallee2, cm48_sdcciyp_m482d

cm48_sdcciy_pow_callee:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x

l0_cm48_sdcciy_pow_callee:

   exx
   
   call am48_pow

   jp cm48_sdcciyp_m482d
