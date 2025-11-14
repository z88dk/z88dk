
; float fma(float x, float y, float z) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_fma_callee

EXTERN cm48_sdcciyp_dcallee2, am48_dmul, cm48_sdcciyp_m482d, cm48_sdcciyp_d2m48, am48_dadd

cm48_sdcciy_fma_callee:

   call cm48_sdcciyp_dcallee2

   ; AC'= y
   ; AC = x
   ; stack = z, ret

   ; fma operation performed here since
   ; it is difficult to gather three params

   call am48_dmul

   pop bc
   
   pop de
   pop hl                      ; hlde = float z
   
   push bc
   
   jp c, cm48_sdcciyp_m482d    ; if overflow
   
   call cm48_sdcciyp_d2m48
   
   ; AC = x * y
   ; AC'= z
   
   call am48_dadd
   
   jp cm48_sdcciyp_m482d
