; CALLEE linkage for function pointers

XLIB calloc

LIB HeapCalloc_callee
XREF _heap, ASMDISP_HEAPCALLOC_CALLEE

.calloc

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   ld bc,_heap
   jp HeapCalloc_callee + ASMDISP_HEAPCALLOC_CALLEE
