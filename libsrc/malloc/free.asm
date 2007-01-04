; void __FASTCALL__ free(void *addr)
; 12.2006 aralbrec

XLIB free
XDEF ASMDISP_FREE

LIB HeapFree
XREF _heap, ASMDISP_HEAPFREE

.free

   ld de,_heap
   jp HeapFree + ASMDISP_HEAPFREE

DEFC ASMDISP_FREE = 0
