; int adt_ListAppend(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

; CALLER linkage for function pointers

PUBLIC adt_ListAppend

EXTERN adt_ListAppend_callee
EXTERN ASMDISP_ADT_LISTAPPEND_CALLEE

.adt_ListAppend

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp adt_ListAppend_callee + ASMDISP_ADT_LISTAPPEND_CALLEE
