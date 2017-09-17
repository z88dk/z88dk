; CALLER linkage for function pointers

SECTION code_clib
PUBLIC realloc
PUBLIC _realloc

EXTERN realloc_callee
EXTERN ASMDISP_REALLOC_CALLEE

.realloc
._realloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp realloc_callee + ASMDISP_REALLOC_CALLEE
