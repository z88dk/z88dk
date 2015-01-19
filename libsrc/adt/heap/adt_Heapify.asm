; void adt_Heapify(void **array, uint n, void *compare)
; CALLER linkage for function pointers

PUBLIC adt_Heapify
EXTERN ADTHeapify, ADThcompare

.adt_Heapify

   pop de
   pop iy
   pop hl
   pop bc
   push bc
   push hl
   push hl
   push de
   ld ix,ADThcompare
   jp ADTHeapify
