
; float ldexp(float x, int exp) __z88dk_callee

SECTION code_fp_math48

PUBLIC cm48_sdcciy_ldexp

EXTERN cm48_sdcciyp_d2m48, am48_ldexp, cm48_sdcciyp_m482d

cm48_sdcciy_ldexp:

   pop af
   
   pop de
   pop hl                      ; hlde'= float x
   
   exx
   
   pop hl                      ; hl = exp
   
   push af

   exx
   
   call cm48_sdcciyp_d2m48

   call am48_ldexp
   
   jp cm48_sdcciyp_m482d
