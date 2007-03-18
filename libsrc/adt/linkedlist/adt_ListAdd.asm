; int adt_ListAdd(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

; CALLER linkage for function pointers

XLIB adt_ListAdd

LIB adt_ListAdd_callee
XREF ASMDISP_ADT_LISTADD_CALLEE

.adt_ListAdd

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp adt_ListAdd_callee + ASMDISP_ADT_LISTADD_CALLEE
