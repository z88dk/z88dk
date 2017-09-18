; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapSbrk
PUBLIC _HeapSbrk

EXTERN HeapSbrk_callee
EXTERN ASMDISP_HEAPSBRK_CALLEE

.HeapSbrk
._HeapSbrk

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp HeapSbrk_callee + ASMDISP_HEAPSBRK_CALLEE
