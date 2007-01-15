; CALLER linkage for function pointers

XLIB HeapAlloc

LIB HeapAlloc_callee
XREF ASMDISP_HEAPALLOC_CALLEE

.HeapAlloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp HeapAlloc_callee + ASMDISP_HEAPALLOC_CALLEE
