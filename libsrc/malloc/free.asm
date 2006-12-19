; void __FASTCALL__ free(void *addr)
; 12.2006 aralbrec

XLIB free
LIB MAHeapFree
XREF _heap

.free

   ld de,_heap
   jp MAHeapFree
