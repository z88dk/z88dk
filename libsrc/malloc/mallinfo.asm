; CALLER linkage for function pointers

PUBLIC mallinfo

EXTERN HeapInfo
EXTERN _heap

.mallinfo

   ld hl,_heap
   ex (sp),hl
   push hl
   jp HeapInfo
