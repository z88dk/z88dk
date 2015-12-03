
; float rint(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_rint

EXTERN cm48_sdccix_rint_fastcall

cm48_sdccix_rint:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_rint_fastcall
