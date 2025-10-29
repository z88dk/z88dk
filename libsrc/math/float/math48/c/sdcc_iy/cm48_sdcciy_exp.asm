
; float exp(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_exp

EXTERN cm48_sdcciy_exp_fastcall

cm48_sdcciy_exp:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_exp_fastcall
