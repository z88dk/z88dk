
; float scalbn(float x, int n) __z88dk_callee

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_scalbn_callee, l0_cm48_sdccix_scalbn_callee

EXTERN cm48_sdccixp_d2m48, am48_scalbn, cm48_sdccixp_m482d

cm48_sdccix_scalbn_callee:

   pop af
   
   pop de
   pop hl                      ; hlde = float x
   
   exx
   
   pop hl                      ; hl = int n
   
   exx
   
   push af

l0_cm48_sdccix_scalbn_callee:

   call cm48_sdccixp_d2m48
   
   ; AC'= double x
   ; hl = n
   
   call am48_scalbn

   jp cm48_sdccixp_m482d
