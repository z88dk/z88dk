
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dcallee2

EXTERN cm48_sdcciyp_d2m48

cm48_sdcciyp_dcallee2:

   ; Collect two callee sdcc_float parameters from the stack.
   ;
   ; Convert to math48 format.
   ;
   ; enter : stack = float sdcc_right, float sdcc_left, ret1, ret0
   ;
   ; exit  : AC = double left (math48)
   ;         AC'= double right (math48)
   
   pop af
   pop bc
   
   pop de
   pop hl                      ; hlde = sdcc_left
   
   exx
   
   pop de
   pop hl                      ; hlde'= sdcc_right
   
   exx
   
   push bc
   push af
   
   call cm48_sdcciyp_d2m48
   jp cm48_sdcciyp_d2m48
   
   ; AC = double left
   ; AC'= double right
