
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfNotRem_fastcall

EXTERN asm_sp1_DrawUpdateStructIfNotRem

_sp1_DrawUpdateStructIfNotRem_fastcall:
   
   push ix
   
   call asm_sp1_DrawUpdateStructIfNotRem
   
   push ix
   ret
