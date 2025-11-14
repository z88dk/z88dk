; void adt_ListConcat(struct adt_List *list1, struct sp_List *list2)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListConcat
PUBLIC _adt_ListConcat

EXTERN asm_adt_ListConcat

.adt_ListConcat
._adt_ListConcat

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp asm_adt_ListConcat
