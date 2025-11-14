
; float fmod(float x, float y) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_fmod_callee, l0_cm48_sdcciy_fmod_callee

EXTERN am48_fmod, cm48_sdcciyp_dcallee2, cm48_sdcciyp_m482d

cm48_sdcciy_fmod_callee:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x

l0_cm48_sdcciy_fmod_callee:

   exx
   
   call am48_fmod

   jp cm48_sdcciyp_m482d
