; void __CALLEE__ HeapInfo_callee(unsigned int *total, unsigned int *largest, void *heap)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapInfo_callee
PUBLIC _HeapInfo_callee
EXTERN MAHeapInfo

.HeapInfo_callee
._HeapInfo_callee

   pop af
   pop hl
   push af
   call MAHeapInfo
   pop af
   pop hl
   ld (hl),c
   inc hl
   ld (hl),b
   pop hl
   ld (hl),e
   inc hl
   ld (hl),d
   push af
   ret
