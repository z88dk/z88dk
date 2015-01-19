; CALLER linkage for function pointers

PUBLIC HeapSbrk

EXTERN HeapSbrk_callee
EXTERN ASMDISP_HEAPSBRK_CALLEE

.HeapSbrk

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp HeapSbrk_callee + ASMDISP_HEAPSBRK_CALLEE
