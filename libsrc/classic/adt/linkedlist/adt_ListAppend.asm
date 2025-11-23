; int adt_ListAppend(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListAppend
PUBLIC _adt_ListAppend

EXTERN asm_adt_ListAppend

.adt_ListAppend
._adt_ListAppend

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp asm_adt_ListAppend
