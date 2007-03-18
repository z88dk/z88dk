; void adt_ListConcat(struct adt_List *list1, struct sp_List *list2)
; CALLER linkage for function pointers

XLIB adt_ListConcat

LIB adt_ListConcat_callee
XREF ASMDISP_ADT_LISTCONCAT_CALLEE

.adt_ListConcat

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp adt_ListConcat_callee + ASMDISP_ADT_LISTCONCAT_CALLEE
