; void __CALLEE__ mallinfo_callee(unsigned int *total, unsigned int *largest)
; 12.2006 aralbrec

XLIB mallinfo_callee

LIB HeapInfo_callee
XREF _heap

.mallinfo_callee

   ld hl,_heap
   ex (sp),hl
   push hl
   jp HeapInfo_callee

