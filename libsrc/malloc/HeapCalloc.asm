; CALLER linkage for function pointers

XLIB HeapCalloc

LIB HeapCalloc_callee
XREF ASMDISP_HEAPCALLOC_CALLEE

.HeapCalloc

   pop af
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
   push af
   
   jp HeapCalloc_callee + ASMDISP_HEAPCALLOC_CALLEE
