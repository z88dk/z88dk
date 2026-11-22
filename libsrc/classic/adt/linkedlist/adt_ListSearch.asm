; void *adt_ListSearch(struct adt_List *list, void *match, void *item1)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListSearch
PUBLIC _adt_ListSearch

EXTERN asm_adt_ListSearch

.adt_ListSearch
._adt_ListSearch

   pop bc
   pop de
   pop iy
   pop hl
   push hl
   push hl
   push de
   push bc
   
   jp asm_adt_ListSearch
