; int adt_ListAdd(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListAdd
PUBLIC _adt_ListAdd

EXTERN adt_ListAdd_callee
EXTERN ASMDISP_ADT_LISTADD_CALLEE

.adt_ListAdd
._adt_ListAdd

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp adt_ListAdd_callee + ASMDISP_ADT_LISTADD_CALLEE
