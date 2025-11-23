
; float fma(float x, float y, float z) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_fma

EXTERN cm48_sdcciyp_dread2, am48_dmul, cm48_sdcciyp_m482d, cm48_sdcciyp_dload, cm48_sdcciyp_d2m48, am48_dadd

cm48_sdcciy_fma:

   call cm48_sdcciyp_dread2

   ; AC'= y
   ; AC = x
   ; stack = z, y, x, ret

   ; fma operation performed here since
   ; it is difficult to gather three params

   call am48_dmul

   jp c, cm48_sdcciyp_m482d    ; if overflow

   ld hl,10
   add hl,sp
   
   call cm48_sdcciyp_dload
   
   ; AC = x * y
   ; AC'= z
   
   call am48_dadd
   
   jp cm48_sdcciyp_m482d
