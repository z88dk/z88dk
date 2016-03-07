; void __FASTCALL__ free(void *addr)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC free

EXTERN HeapFree_callee
EXTERN _heap, ASMDISP_HEAPFREE_CALLEE

.free

   ld de,_heap
   jp HeapFree_callee + ASMDISP_HEAPFREE_CALLEE
