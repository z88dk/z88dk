
; float fabs(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_fabs

EXTERN cm48_sdcciy_fabs_fastcall

cm48_sdcciy_fabs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_fabs_fastcall
