
; float tanh(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_tanh

EXTERN cm48_sdccix_tanh_fastcall

cm48_sdccix_tanh:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_tanh_fastcall
