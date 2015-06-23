
; float fmax(float x, float y) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdcciy_fmax

EXTERN am48_fmax, cm48_sdcciyp_dcallee2, cm48_sdcciyp_m482d

cm48_sdcciy_fmax:

   call cm48_sdcciyp_dcallee2
   
   ; AC'= y
   ; AC = x
   
   call am48_fmax

   jp cm48_sdcciyp_m482d
