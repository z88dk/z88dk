
; float tgamma(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_tgamma

EXTERN cm48_sdcciy_tgamma_fastcall

cm48_sdcciy_tgamma:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_tgamma_fastcall
