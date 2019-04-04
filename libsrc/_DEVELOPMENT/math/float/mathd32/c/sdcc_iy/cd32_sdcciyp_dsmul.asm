
; float __fsmul (float a1, float a2)

SECTION code_clib
SECTION code_fp_d32

PUBLIC cd32_sdcciyp_dsmul

EXTERN cd32_sdcciyp_dread2, md32_mul, cd32_sdcciyp_d322d

cd32_sdcciyp_dsmul:

   ; multiply two sdcc floats
   ;
   ; enter : stack = sdcc float a2, sdcc_float a1, ret
   ;
   ; exit  : HLDE = sdcc float(a1*a2)
   ;
   ; uses  : af, bc, de, hl
   
   call cd32_sdcciyp_dread2
   
   call md32_mul
   
   jp cd32_sdcciyp_d322d
