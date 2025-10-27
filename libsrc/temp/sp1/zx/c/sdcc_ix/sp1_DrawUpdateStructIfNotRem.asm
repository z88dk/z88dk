
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfNotRem

EXTERN _sp1_DrawUpdateStructIfNotRem_fastcall

_sp1_DrawUpdateStructIfNotRem:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _sp1_DrawUpdateStructIfNotRem_fastcall
