; void adt_ListSetCurr(struct adt_List *list, struct adt_ListNode *n)
; CALLER linkage for function pointers

PUBLIC adt_ListSetCurr

EXTERN adt_ListSetCurr_callee
EXTERN ASMDISP_ADT_LISTSETCURR_CALLEE

.adt_ListSetCurr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp adt_ListSetCurr_callee + ASMDISP_ADT_LISTSETCURR_CALLEE
