; CALLER linkage for function pointers

PUBLIC HeapRealloc

EXTERN HeapRealloc_callee
EXTERN ASMDISP_HEAPREALLOC_CALLEE

.HeapRealloc

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp HeapRealloc_callee + ASMDISP_HEAPREALLOC_CALLEE
