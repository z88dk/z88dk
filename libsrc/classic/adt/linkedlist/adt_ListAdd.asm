; int adt_ListAdd(struct adt_List *list, void *item)
; 02.2003, 06.2005 aralbrec

; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListAdd
PUBLIC _adt_ListAdd

EXTERN asm_adt_ListAdd

.adt_ListAdd
._adt_ListAdd

   pop hl
   pop bc
   pop de
   push de
   push bc
   push hl
   
   jp asm_adt_ListAdd
