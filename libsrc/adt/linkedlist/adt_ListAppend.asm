; int adt_ListAppend(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

; CALLER linkage for function pointers

XLIB adt_ListAppend

LIB adt_ListAppend_callee
XREF ASMDISP_ADT_LISTAPPEND_CALLEE

.adt_ListAppend

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp adt_ListAppend_callee + ASMDISP_ADT_LISTAPPEND_CALLEE
