
; float erfc(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_erfc

EXTERN cm48_sdcciy_erfc_fastcall

cm48_sdcciy_erfc:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp cm48_sdcciy_erfc_fastcall
