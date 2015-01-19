; void adt_HeapAdd(void *item, void **array, uint *n, void *compare)
; CALLER linkage for function pointers

PUBLIC adt_HeapAdd

EXTERN adt_HeapAdd_callee
EXTERN CDISP_ADT_HEAPADD_CALLEE

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
   
   jp adt_HeapAdd_callee + CDISP_ADT_HEAPADD_CALLEE
