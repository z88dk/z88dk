
; float ldexp(float x, int exp) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_ldexp_callee, l0_cm48_sdccix_ldexp_callee

EXTERN cm48_sdccixp_d2m48, am48_ldexp, cm48_sdccixp_m482d

cm48_sdccix_ldexp_callee:

   pop af
   
   pop de
   pop hl                      ; hlde'= float x
   
   exx
   
   pop hl                      ; hl = exp
   
   push af

l0_cm48_sdccix_ldexp_callee:

   exx
   
   call cm48_sdccixp_d2m48

   call am48_ldexp
   
   jp cm48_sdccixp_m482d
