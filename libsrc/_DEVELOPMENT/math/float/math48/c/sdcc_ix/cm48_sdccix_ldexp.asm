
; float ldexp(float x, int exp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_ldexp

EXTERN l0_cm48_sdccix_ldexp_callee

cm48_sdccix_ldexp:

   pop af
   
   pop de
   pop hl                      ; hlde'= float x
   
   exx
   
   pop hl                      ; hl = exp
   
   push hl
   
   push hl
   push de
   
   push af

   jp l0_cm48_sdccix_ldexp_callee
