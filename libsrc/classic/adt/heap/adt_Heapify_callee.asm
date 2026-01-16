; void __LIB__ adt_Heapify_callee(void **array, uint n, void *compare)
; 08.2005 aralbrec

SECTION code_clib
PUBLIC adt_Heapify_callee
PUBLIC _adt_Heapify_callee
EXTERN ADTHeapify, ADThcompare

.adt_Heapify_callee
._adt_Heapify_callee

   pop de
   pop iy
   pop hl
   pop bc
   push de
   push ix
   ld ix,ADThcompare
   call ADTHeapify
   pop ix
   ret
