; void mallinfo(unsigned int *total, unsigned int *largest)
; 12.2006 aralbrec

XLIB mallinfo

LIB HeapInfo
XREF _heap, CDISP_HEAPINFO

.mallinfo

   ld hl,_heap
   jp HeapInfo + CDISP_HEAPINFO
