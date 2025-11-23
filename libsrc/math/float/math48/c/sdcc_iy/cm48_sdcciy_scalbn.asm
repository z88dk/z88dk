
; float scalbn(float x, int n)

SECTION code_clib
SECTION code_fp_math48

PUBLIC cm48_sdcciy_scalbn

EXTERN l0_cm48_sdcciy_scalbn_callee

cm48_sdcciy_scalbn:

   pop af
   
   pop de
   pop hl                      ; hlde = float x
   
   exx
   
   pop hl                      ; hl = int n
   
   push hl
   
   exx
   
   push hl
   push de
   
   push af

   jp l0_cm48_sdcciy_scalbn_callee
