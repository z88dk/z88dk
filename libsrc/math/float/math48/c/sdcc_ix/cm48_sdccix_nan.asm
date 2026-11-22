
; float nan(const char *tagp)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdccix_nan

EXTERN cm48_sdccix_nan_fastcall

cm48_sdccix_nan:

   pop af
   pop hl
   
   push hl
   push af
   
   jp cm48_sdccix_nan_fastcall
