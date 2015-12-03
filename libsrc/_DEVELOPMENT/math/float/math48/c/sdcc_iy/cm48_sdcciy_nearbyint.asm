
; float nearbyint(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_nearbyint

EXTERN cm48_sdcciy_nearbyint_fastcall

cm48_sdcciy_nearbyint:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_nearbyint_fastcall
