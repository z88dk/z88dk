
; float floor(float x)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_floor

EXTERN cm48_sdcciy_floor_fastcall

cm48_sdcciy_floor:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_floor_fastcall
