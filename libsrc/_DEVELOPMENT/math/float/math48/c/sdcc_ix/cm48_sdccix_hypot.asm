
; float hypot(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdccix_hypot

EXTERN am48_hypot, cm48_sdccixp_dcallee2, cm48_sdccixp_m482d

cm48_sdccix_hypot:

   call cm48_sdccixp_dcallee2
   
   ; AC'= y
   ; AC = x
   
   call am48_hypot

   jp cm48_sdccixp_m482d
