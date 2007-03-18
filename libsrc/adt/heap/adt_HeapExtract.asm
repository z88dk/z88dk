; void *adt_HeapExtract(void **array, uint *n, void *compare)
; CALLER linkage for function pointers

XLIB adt_HeapExtract
LIB ADTHeapExtract, ADThcompare

.adt_HeapExtract

   pop bc
   pop iy
   pop hl
   pop de
   push de
   push hl
   push hl
   push bc
   ld ix,ADThcompare
   jp ADTHeapExtract
