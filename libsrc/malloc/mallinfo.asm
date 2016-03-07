; CALLER linkage for function pointers

SECTION code_clib
PUBLIC mallinfo

EXTERN HeapInfo
EXTERN _heap

.mallinfo

   ld hl,_heap
   ex (sp),hl
   push hl
   jp HeapInfo
