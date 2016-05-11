; int adt_ListInsert(struct adt_List *list, void *item)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListInsert
PUBLIC _adt_ListInsert

EXTERN adt_ListInsert_callee
EXTERN ASMDISP_ADT_LISTINSERT_CALLEE

.adt_ListInsert
._adt_ListInsert

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp adt_ListInsert_callee + ASMDISP_ADT_LISTINSERT_CALLEE

