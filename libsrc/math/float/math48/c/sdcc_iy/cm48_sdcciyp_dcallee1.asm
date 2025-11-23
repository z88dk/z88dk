
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dcallee1

EXTERN cm48_sdcciyp_d2m48

cm48_sdcciyp_dcallee1:

   ; Collect one sdcc_float from the stack,
   ;
   ; Convert to math48 format.
   ;
   ; enter : stack = sdcc_float x, ret1, ret0
   ;
   ; exit  : AC'= double x (math48)
   
   pop af
   pop bc
   
   pop de
   pop hl                      ; hlde = x
   
   push bc
   push af
   
   jp cm48_sdcciyp_d2m48
