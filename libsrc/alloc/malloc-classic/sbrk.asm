; CALLER linkage for function pointers

SECTION code_clib
PUBLIC sbrk
PUBLIC _sbrk

EXTERN sbrk_callee
EXTERN ASMDISP_SBRK_CALLEE

.sbrk
._sbrk

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp sbrk_callee + ASMDISP_SBRK_CALLEE
