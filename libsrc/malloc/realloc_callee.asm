; void __CALLEE__ *realloc_callee(void *p, unsigned int size)
; 12.2006 aralbrec

XLIB realloc_callee
XDEF ASMDISP_REALLOC_CALLEE

LIB HeapRealloc_callee
XREF _heap, ASMDISP_HEAPREALLOC_CALLEE

.realloc_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

   ; hl = void *p
   ; bc = size
   
   ld de,_heap
   jp HeapRealloc_CALLEE + ASMDISP_HEAPREALLOC_CALLEE

DEFC ASMDISP_REALLOC_CALLEE = asmentry - realloc_callee
