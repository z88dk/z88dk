
SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciyp_dcallee3

cm48_sdcciyp_dcallee3:

   ; Collect one 64-bit int from the stack,
   ;
   ; enter : stack = long long x, ret1, ret0
   ;
   ; exit  : dehl'dehl = x
   ;
   ; uses  : af, bc, de, hl, de', hl'
   
   pop af
   pop bc

   pop hl
   pop de
   exx
   pop hl
   pop de
   exx
   
   push bc
   push af
   
   ret
