
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfVal

EXTERN _sp1_DrawUpdateStructIfVal_fastcall

_sp1_DrawUpdateStructIfVal:

   pop af
   pop hl
   
   push hl
   push af

   jp _sp1_DrawUpdateStructIfVal_fastcall
