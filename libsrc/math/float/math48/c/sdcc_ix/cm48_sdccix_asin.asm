
; float asin(float x) __z88dk_fastcall

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_asin

EXTERN cm48_sdccix_asin_fastcall

cm48_sdccix_asin:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_asin_fastcall
