; void __CALLEE__  adt_HeapAdd_callee(void *item, void **array, uint *n, void *compare)
; 08.2005 aralbrec

XLIB adt_HeapAdd_callee
LIB ADTHeapAdd, ADThcompare

.adt_HeapAdd_callee

   pop af
   pop iy
   pop hl
   pop bc
   pop de
   push af
   ld ix,ADThcompare
   jp ADTHeapAdd
