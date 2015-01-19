; CALLER linkage for function pointers

PUBLIC sbrk

EXTERN sbrk_callee
EXTERN ASMDISP_SBRK_CALLEE

.sbrk

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp sbrk_callee + ASMDISP_SBRK_CALLEE
