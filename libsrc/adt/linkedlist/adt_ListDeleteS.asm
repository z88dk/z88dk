; void adt_ListDeleteS(struct adt_List *list, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListDeleteS
PUBLIC _adt_ListDeleteS

EXTERN asm_adt_ListDeleteS

.adt_ListDeleteS
._adt_ListDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_adt_ListDeleteS
