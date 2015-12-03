
; float hypot(float x, float y) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_hypot_callee, l0_cm48_sdcciy_hypot_callee

EXTERN am48_hypot, cm48_sdcciyp_dcallee2, cm48_sdcciyp_m482d

cm48_sdcciy_hypot_callee:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x

l0_cm48_sdcciy_hypot_callee:

   call am48_hypot

   jp cm48_sdcciyp_m482d
