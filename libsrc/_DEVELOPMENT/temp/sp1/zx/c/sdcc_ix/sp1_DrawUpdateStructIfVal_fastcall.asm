
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfVal_fastcall

EXTERN asm_sp1_DrawUpdateStructIfVal

_sp1_DrawUpdateStructIfVal_fastcall:

   push ix
   
   call asm_sp1_DrawUpdateStructIfVal
   
   pop ix
   ret
