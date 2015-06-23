
; float atan2(float y, float x) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdcciy_atan2

EXTERN am48_atan2, cm48_sdcciyp_dcallee2, cm48_sdcciyp_m482d

cm48_sdcciy_atan2:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x
   
   exx
   call am48_atan2

   jp cm48_sdcciyp_m482d
