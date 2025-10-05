; int adt_ListPrepend(struct adt_List *list, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListPrepend
PUBLIC _adt_ListPrepend

EXTERN asm_adt_ListPrepend

.adt_ListPrepend
._adt_ListPrepend

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp asm_adt_ListPrepend
