; void __CALLEE__ *realloc_callee(void *p, unsigned int size)
; 12.2006 aralbrec

PUBLIC realloc_callee
PUBLIC ASMDISP_REALLOC_CALLEE

EXTERN HeapRealloc_callee
EXTERN _heap, ASMDISP_HEAPREALLOC_CALLEE

.realloc_callee

   pop hl
   pop bc
   ex (sp),hl

.asmentry

   ; hl = void *p
   ; bc = size
   
   ld de,_heap
   jp HeapRealloc_callee + ASMDISP_HEAPREALLOC_CALLEE

DEFC ASMDISP_REALLOC_CALLEE = # asmentry - realloc_callee
