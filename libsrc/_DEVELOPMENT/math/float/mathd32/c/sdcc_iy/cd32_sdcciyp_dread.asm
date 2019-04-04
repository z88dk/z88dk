
SECTION code_clib
SECTION code_fp_d32

PUBLIC cd32_sdcciyp_dread1, cd32_sdcciyp_dread2

EXTERN cd32_sdcciyp_dload

.cd32_sdcciyp_dread2

   ; sdcc float primitive
   ; Read two sdcc floats from the stack
   ;
   ; Convert from sdcc float format to math48 format.
   ;
   ; enter : stack = sdcc_float right, sdcc_float left, ret1, ret0
   ;
   ; exit  : BCDE = float left (d32)
   ;         stack = float right (d32)
   ; 
   ; uses  : af, bc, de, hl
   
   ld hl,8
   add hl,sp
   
   call cd32_sdcciyp_dload
   
   push de
   push bc

.cd32_sdcciyp_dread1

   ld hl,8
   add hl,sp
   
   jp cd32_sdcciyp_dload

