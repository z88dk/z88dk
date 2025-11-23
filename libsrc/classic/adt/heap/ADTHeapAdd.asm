; void adt_HeapAdd(void *item, void **array, uint n, void *compare)
; 08.2005 aralbrec

SECTION code_clib
PUBLIC ADTHeapAdd
EXTERN ADTHeapSiftUp

; enter:  HL = N+1 (number of items in array after this one added)
;         BC = array address
;         DE = &item
;         IX = compare(DE=&array[child], HL=&array[parent])
;              set carry if child < parent (min heap) -- MUST PRESERVE BC,DE,HL,IX

.ADTHeapAdd
   add hl,hl
   push hl
   add hl,bc            ; hl = &array[N+1]
   ld (hl),e            ; store new item at end of array
   inc hl
   ld (hl),d
   dec hl
   pop de               ; de = start index * 2
   jp ADTHeapSiftUp
