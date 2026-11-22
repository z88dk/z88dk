; void adt_Heapify(void **array, uint n, void *compare)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_Heapify
PUBLIC _adt_Heapify
EXTERN ADTHeapify, ADThcompare

.adt_Heapify
._adt_Heapify

   pop de
   pop iy
   pop hl
   pop bc
   push bc
   push hl
   push hl
   push de
   push ix
   ld ix,ADThcompare
   call  ADTHeapify
   pop ix
   ret
