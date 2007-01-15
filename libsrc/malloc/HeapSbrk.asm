; CALLER linkage for function pointers

XLIB HeapSbrk

LIB HeapSbrk_callee
XREF ASMDISP_HEAPSBRK_CALLEE

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
