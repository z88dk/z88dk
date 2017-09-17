; void __FASTCALL__ *malloc(unsigned int size)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC malloc
PUBLIC _malloc

EXTERN HeapAlloc_callee
EXTERN _heap, ASMDISP_HEAPALLOC_CALLEE

.malloc
._malloc

   ld c,l
   ld b,h
   ld hl,_heap

   jp HeapAlloc_callee + ASMDISP_HEAPALLOC_CALLEE
