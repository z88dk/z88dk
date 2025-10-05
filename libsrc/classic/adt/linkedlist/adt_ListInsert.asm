; int adt_ListInsert(struct adt_List *list, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListInsert
PUBLIC _adt_ListInsert

EXTERN asm_adt_ListInsert

.adt_ListInsert
._adt_ListInsert

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp asm_adt_ListInsert

