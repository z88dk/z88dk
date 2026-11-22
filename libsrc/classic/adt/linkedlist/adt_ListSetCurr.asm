; void adt_ListSetCurr(struct adt_List *list, struct adt_ListNode *n)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListSetCurr
PUBLIC _adt_ListSetCurr

EXTERN asm_adt_ListSetCurr

.adt_ListSetCurr
._adt_ListSetCurr

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp asm_adt_ListSetCurr
