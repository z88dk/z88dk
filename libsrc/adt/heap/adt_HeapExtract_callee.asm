; void __CALLEE__ *adt_HeapExtract_callee(void **array, uint *n, void *compare)
; 08.2005 aralbrec

PUBLIC adt_HeapExtract_callee
PUBLIC CDISP_ADT_HEAPEXTRACT_CALLEE

EXTERN ADTHeapExtract, ADThcompare

.adt_HeapExtract_callee

   pop bc
   pop iy
   pop hl
   pop de
   push bc
   
.centry
   
   push hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   push hl
   
   ld ix,ADThcompare
   call ADTHeapExtract
   jr nc, nothing
   
   pop de
   ld c,l
   ld b,h
   pop hl
   dec de
   ld (hl),e
   inc hl
   ld (hl),d
   
   ld l,c
   ld h,b
   ret

.nothing

   pop hl
   pop hl
   ld hl,0
   ret

DEFC CDISP_ADT_HEAPEXTRACT_CALLEE = # centry - adt_HeapExtract_callee
