
; float sinh(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_sinh

EXTERN cm48_sdccix_sinh_fastcall

cm48_sdccix_sinh:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_sinh_fastcall
