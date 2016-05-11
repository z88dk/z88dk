; void adt_ListDeleteS(struct adt_List *list, void *delete)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC adt_ListDeleteS
PUBLIC _adt_ListDeleteS

EXTERN adt_ListDeleteS_callee
EXTERN ASMDISP_ADT_LISTDELETES_CALLEE

.adt_ListDeleteS
._adt_ListDeleteS

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp adt_ListDeleteS_callee + ASMDISP_ADT_LISTDELETES_CALLEE
