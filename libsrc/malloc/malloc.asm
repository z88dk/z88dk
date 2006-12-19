; void __FASTCALL__ *malloc(unsigned int size)
; 12.2006 aralbrec

XLIB malloc
LIB MAHeapAlloc
XREF _heap

.malloc

   ld c,l
   ld b,h
   ld hl,_heap
   jp MAHeapAlloc
