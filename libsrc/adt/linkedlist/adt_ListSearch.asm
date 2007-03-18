; void *adt_ListSearch(struct adt_List *list, void *match, void *item1)
; CALLER linkage for function pointers

XLIB adt_ListSearch

LIB adt_ListSearch_callee
XREF ASMDISP_ADT_LISTSEARCH_CALLEE

.adt_ListSearch

   pop bc
   pop de
   pop iy
   pop hl
   push hl
   push hl
   push de
   push bc
   
   jp adt_ListSearch_callee + ASMDISP_ADT_LISTSEARCH_CALLEE
