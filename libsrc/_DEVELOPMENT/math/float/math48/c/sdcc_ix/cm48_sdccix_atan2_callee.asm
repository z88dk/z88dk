
; float atan2(float y, float x) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_atan2_callee, l0_cm48_sdccix_atan2_callee

EXTERN am48_atan2, cm48_sdccixp_dcallee2, cm48_sdccixp_m482d

cm48_sdccix_atan2_callee:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x

l0_cm48_sdccix_atan2_callee:

   exx
   call am48_atan2

   jp cm48_sdccixp_m482d
