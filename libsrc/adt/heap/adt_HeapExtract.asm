; void *adt_HeapExtract(void **array, uint *n, void *compare)
; CALLER linkage for function pointers

PUBLIC adt_HeapExtract

EXTERN adt_HeapExtract_callee
EXTERN CDISP_HEAPEXTRACT_CALLEE

.adt_HeapExtract

   pop bc
   pop iy
   pop hl
   pop de
   push de
   push hl
   push hl
   push bc
   
   jp adt_HeapExtract_callee + CDISP_HEAPEXTRACT_CALLEE
