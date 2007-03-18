; void adt_ListDelete(struct adt_List *list, void *delete)
; CALLER linkage for function pointers

XLIB adt_ListDelete

LIB adt_ListDelete_callee
XREF ASMDISP_ADT_LISTDELETE_CALLEE

.adt_ListDelete

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_ListDelete_callee + ASMDISP_ADT_LISTDELETE_CALLEE
