; void __FASTCALL__ *malloc(unsigned int size)
; 12.2006 aralbrec

XLIB malloc
XDEF ASMDISP_MALLOC

LIB HeapAlloc
XREF _heap, ASMDISP_HEAPALLOC

.malloc

   ld c,l
   ld b,h
   ld hl,_heap
   jp HeapAlloc + ASMDISP_HEAPALLOC

DEFC ASMDISP_MALLOC = 0
