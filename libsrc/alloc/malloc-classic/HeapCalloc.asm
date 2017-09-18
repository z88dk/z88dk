; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapCalloc
PUBLIC _HeapCalloc

EXTERN HeapCalloc_callee
EXTERN ASMDISP_HEAPCALLOC_CALLEE

.HeapCalloc
._HeapCalloc

   pop af
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
   push af
   
   jp HeapCalloc_callee + ASMDISP_HEAPCALLOC_CALLEE
