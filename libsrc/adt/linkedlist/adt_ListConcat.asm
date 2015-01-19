; void adt_ListConcat(struct adt_List *list1, struct sp_List *list2)
; CALLER linkage for function pointers

PUBLIC adt_ListConcat

EXTERN adt_ListConcat_callee
EXTERN ASMDISP_ADT_LISTCONCAT_CALLEE

.adt_ListConcat

   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   
   jp adt_ListConcat_callee + ASMDISP_ADT_LISTCONCAT_CALLEE
