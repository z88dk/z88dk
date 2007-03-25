; void __CALLEE__  adt_HeapAdd_callee(void *item, void **array, uint *n, void *compare)
; 08.2005 aralbrec

XLIB adt_HeapAdd_callee
XDEF CDISP_ADT_HEAPADD_CALLEE

LIB ADTHeapAdd, ADThcompare

.adt_HeapAdd_callee

   pop af
   pop iy
   pop hl
   pop bc
   pop de
   push af

.centry

   inc (hl)
   ld a,(hl)
   inc hl
   jr nz, noinchi
   inc (hl)

.noinchi

   ld h,(hl)
   ld l,a
   
   ld ix,ADThcompare
   jp ADTHeapAdd

DEFC CDISP_ADT_HEAPADD_CALLEE = centry - adt_HeapAdd_callee
