; void adt_ListSetCurr(struct adt_List *list, struct adt_ListNode *n)
; CALLER linkage for function pointers

XLIB adt_ListSetCurr

LIB adt_ListSetCurr_callee
XREF ASMDISP_ADT_LISTSETCURR_CALLEE

.adt_ListSetCurr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp adt_ListSetCurr_callee + ASMDISP_ADT_LISTSETCURR_CALLEE
