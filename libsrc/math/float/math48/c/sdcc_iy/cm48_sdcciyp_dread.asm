
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dread1, cm48_sdcciyp_dread2

EXTERN cm48_sdcciyp_dload

cm48_sdcciyp_dread2:

   ; sdcc float primitive
   ; Read two sdcc floats from the stack
   ;
   ; Covert from sdcc float format to math48 format.
   ;
   ; enter : stack = sdcc_float right, sdcc_float left, ret1, ret0
   ;
   ; exit  : AC'= double left (math48)
   ;         AC = double right (math48)
   ; 
   ; uses  : af, bc, de, hl, bc', de', hl'
   
   ld hl,8
   add hl,sp
   
   call cm48_sdcciyp_dload

cm48_sdcciyp_dread1:

   ld hl,4
   add hl,sp
   
   jp cm48_sdcciyp_dload

   ; AC = right
   ; AC'= left
