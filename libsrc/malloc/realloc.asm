; void *realloc(void *p, unsigned int size)
; 12.2006 aralbrec

XLIB realloc
XDEF ASMDISP_REALLOC

LIB HeapRealloc
XREF _heap, ASMDISP_HEAPREALLOC

.realloc

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de

.asmentry

   ; hl = void *p
   ; bc = size
   
   ld de,_heap
   jp HeapRealloc + ASMDISP_HEAPREALLOC

DEFC ASMDISP_REALLOC = asmentry - realloc
