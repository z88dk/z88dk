; CALLER linkage for function pointers

SECTION code_clib
PUBLIC mallinfo
PUBLIC _mallinfo

EXTERN HeapInfo
EXTERN _heap

.mallinfo
._mallinfo

   ld hl,_heap
   ex (sp),hl
   push hl
   jp HeapInfo
