; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strpbrk
PUBLIC _strpbrk
EXTERN strpbrk_callee
EXTERN ASMDISP_STRPBRK_CALLEE

.strpbrk
._strpbrk

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp strpbrk_callee + ASMDISP_STRPBRK_CALLEE
   
