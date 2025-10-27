
; float cbrt(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_cbrt

EXTERN cm48_sdcciy_cbrt_fastcall

cm48_sdcciy_cbrt:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_cbrt_fastcall
