
; float fdim(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdccix_fdim

EXTERN am48_fdim, cm48_sdccixp_dcallee2, cm48_sdccixp_m482d

cm48_sdccix_fdim:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x
   
   exx
   call am48_fdim

   jp cm48_sdccixp_m482d
