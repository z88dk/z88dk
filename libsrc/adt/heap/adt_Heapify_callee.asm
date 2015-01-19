; void __LIB__ adt_Heapify_callee(void **array, uint n, void *compare)
; 08.2005 aralbrec

PUBLIC adt_Heapify_callee
EXTERN ADTHeapify, ADThcompare

.adt_Heapify_callee

   pop de
   pop iy
   pop hl
   pop bc
   push de
   ld ix,ADThcompare
   jp ADTHeapify
