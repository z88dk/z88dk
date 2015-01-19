; CALLER linkage for function pointers

PUBLIC strpbrk
EXTERN strpbrk_callee
EXTERN ASMDISP_STRPBRK_CALLEE

.strpbrk

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strpbrk_callee + ASMDISP_STRPBRK_CALLEE
   
