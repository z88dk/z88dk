
; float lround(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_lround

EXTERN cm48_sdcciy_lround_fastcall

cm48_sdcciy_lround:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_lround_fastcall
