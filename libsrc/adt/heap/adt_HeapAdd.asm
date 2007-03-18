; void adt_HeapAdd(void *item, void **array, uint *n, void *compare)
; CALLER linkage for function pointers

XLIB adt_HeapAdd
LIB ADTHeapAdd, ADThcompare

.adt_HeapAdd

   pop af
   pop iy
   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   push hl
   push af
   ld ix,ADThcompare
   jp ADTHeapAdd
