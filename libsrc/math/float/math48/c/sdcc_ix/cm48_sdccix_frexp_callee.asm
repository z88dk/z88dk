
; float frexp(float value, int *exp) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_frexp_callee, l0_cm48_sdccix_frexp_callee

EXTERN cm48_sdccixp_d2m48, am48_frexp, cm48_sdccixp_m482d

cm48_sdccix_frexp_callee:

   pop af
   
   pop de
   pop hl                      ; hlde' = float value
   
   exx
   
   pop hl                      ; hl = exp
   
   push af

l0_cm48_sdccix_frexp_callee:

   exx
   
   call cm48_sdccixp_d2m48
   
   ; AC' = double value
   ; hl  = exp
   
   call am48_frexp
   
   jp cm48_sdccixp_m482d
