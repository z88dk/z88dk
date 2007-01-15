; CALLER linkage for function pointers

XLIB mallinfo

LIB HeapInfo
XREF _heap

.mallinfo

   ld hl,_heap
   ex (sp),hl
   push hl
   jp HeapInfo
