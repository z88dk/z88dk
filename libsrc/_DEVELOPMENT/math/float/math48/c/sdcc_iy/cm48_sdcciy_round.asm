
; float round(float x)

SECTION code_fp_math48

PUBLIC cm48_sdcciy_round

EXTERNcm48_sdcciy_round_fastcall

cm48_sdcciy_round:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp cm48_sdcciy_round_fastcall
