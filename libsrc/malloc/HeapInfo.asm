; CALLER linkage for function pointers

PUBLIC HeapInfo
EXTERN MAHeapInfo

.HeapInfo

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
   push hl
   push hl
   push hl
   push af
   ret
