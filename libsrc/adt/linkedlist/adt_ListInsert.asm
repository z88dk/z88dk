; int adt_ListInsert(struct adt_List *list, void *item)
; CALLER linkage for function pointers

XLIB adt_ListInsert

LIB adt_ListInsert_callee
XREF ASMDISP_ADT_LISTINSERT_CALLEE

.adt_ListInsert

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp adt_ListInsert_callee + ASMDISP_ADT_LISTINSERT_CALLEE

