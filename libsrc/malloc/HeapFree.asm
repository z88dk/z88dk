; CALLER linkage for function pointers

XLIB HeapFree

LIB HeapFree_callee
XREF ASMDISP_HEAPFREE_CALLEE

.HeapFree

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp HeapFree_callee + ASMDISP_HEAPFREE_CALLEE
