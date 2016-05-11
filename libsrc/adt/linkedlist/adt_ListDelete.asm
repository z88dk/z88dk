; void adt_ListDelete(struct adt_List *list, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListDelete
PUBLIC _adt_ListDelete

EXTERN adt_ListDelete_callee
EXTERN ASMDISP_ADT_LISTDELETE_CALLEE

.adt_ListDelete
._adt_ListDelete

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_ListDelete_callee + ASMDISP_ADT_LISTDELETE_CALLEE
