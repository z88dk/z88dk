
; float copysign(float x, float y) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_copysign_callee, l0_cm48_sdccix_copysign_callee

EXTERN am48_copysign, cm48_sdccixp_dcallee2, cm48_sdccixp_m482d

cm48_sdccix_copysign_callee:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x

l0_cm48_sdccix_copysign_callee:

   exx
   call am48_copysign

   jp cm48_sdccixp_m482d
