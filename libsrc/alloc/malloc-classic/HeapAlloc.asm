; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapAlloc
PUBLIC _HeapAlloc

EXTERN HeapAlloc_callee
EXTERN ASMDISP_HEAPALLOC_CALLEE

.HeapAlloc
._HeapAlloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp HeapAlloc_callee + ASMDISP_HEAPALLOC_CALLEE
