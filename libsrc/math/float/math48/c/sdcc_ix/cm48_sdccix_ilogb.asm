
; int ilogb(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_ilogb

EXTERN cm48_sdccix_ilogb_fastcall

cm48_sdccix_ilogb:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdccix_ilogb_fastcall
