
; long lrint(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_lrint

EXTERN cm48_sdcciy_lrint_fastcall

cm48_sdcciy_lrint:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_lrint_fastcall
