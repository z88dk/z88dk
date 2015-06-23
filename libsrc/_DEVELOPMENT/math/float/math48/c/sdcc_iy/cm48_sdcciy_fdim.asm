
; float fdim(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdcciy_fdim

EXTERN am48_fdim, cm48_sdcciyp_dcallee2, cm48_sdcciyp_m482d

cm48_sdcciy_fdim:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x
   
   exx
   call am48_fdim

   jp cm48_sdcciyp_m482d
