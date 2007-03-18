; void __CALLEE__ *adt_HeapExtract_callee(void **array, uint *n, void *compare)
; 08.2005 aralbrec

XLIB adt_HeapExtract_callee
LIB ADTHeapExtract, ADThcompare

.adt_HeapExtract_callee

   pop bc
   pop iy
   pop hl
   pop de
   push bc
   ld ix,ADThcompare
   jp ADTHeapExtract
